#!/bin/bash

CONFIG_FILE=""
DOCKER_MODE=false
GPU_COUNT=2
PARTITION="dgx"
MEMORY="32G"
VLLM=false
QOS=""
TIME=""

# ACTIVATE HARDNESS ENVIRONMENT
source /leonardo_work/EUHPC_D22_034/miniconda3/etc/profile.d/conda.sh
conda activate hardness

while getopts ":c:dg:m:p:vq:t:" opt; do
  case $opt in
    c)
      CONFIG_FILE="$OPTARG"
      ;;
    d)
      DOCKER_MODE=true
      ;;
    g)
      GPU_COUNT="$OPTARG"
      ;;
    m)
      MEMORY="$OPTARG"
      ;;
    p)
      PARTITION="$OPTARG"
      ;;
    q)
      QOS="$OPTARG"
      ;;
    t)
      TIME="$OPTARG"
      ;;
    v)
      VLLM=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# Check required -c argument
if [[ -z "$CONFIG_FILE" ]]; then
  echo "Error: -c <config_file.yaml> is required"
  echo "Usage: $0 -c <config_file.yaml> [-d] [-g <gpu_count>] [-m <memory>] [-p <partition>] [-q <qos>] [-t <time>] [-v]"
  exit 1
fi


# Generate unique ID for this job
JOB_ID=$(date +%Y%m%d_%H%M%S)_$$  # timestamp + process ID
# Alternative: JOB_ID=$(uuidgen | cut -d- -f1)  # first part of UUID

echo "Job ID: $JOB_ID"

## GENERATING ENVIRONMENT FILE DOCKER
if [ "$DOCKER_MODE" = true ]; then
  echo "Generating environment file from config: $CONFIG_FILE and to be used in DOCKER mode"
  if [ "$VLLM" = true ]; then
    python3 generate_env.py --config "$CONFIG_FILE" --env-id "$JOB_ID" --docker --vllm
  else
    python3 generate_env.py --config "$CONFIG_FILE" --env-id "$JOB_ID" --docker
  fi
else
## GENERATION ENVIROMENT FILE FOR CONDA
  echo "Generating environment file from config: $CONFIG_FILE and to be used in CONDA mode"
  if [ "$VLLM" = true ]; then
    python3 generate_env.py --config "$CONFIG_FILE" --env-id "$JOB_ID" --vllm
  else
    python3 generate_env.py --config "$CONFIG_FILE" --env-id "$JOB_ID"
  fi
fi

ENV_FILE=".env_$JOB_ID"
if [ ! -f "$ENV_FILE" ]; then
  echo "Error: Failed to generate environment file: $ENV_FILE"
  exit 1
fi

echo "Environment file generated."
echo "Expermient: $JOB_ID"
mkdir -m 770 -p ./experiments/$JOB_ID
mkdir -m 770 -p ./experiments/$JOB_ID/outputLogs
mv ./$ENV_FILE ./experiments/$JOB_ID
cp $CONFIG_FILE ./experiments/$JOB_ID

# Create a temporary SLURM script with the correct env file
TMP_SCRIPT="slurm_job_${JOB_ID}.slurm"



if [ "$DOCKER_MODE" = true ]; then
  sed -e "s|#SBATCH --output=%j.out|#SBATCH --output=./experiments/$JOB_ID/%j.out|g" \
      -e "s|#SBATCH --error=%j.err|#SBATCH --error=./experiments/$JOB_ID/%j.err|g" \
      -e "s|#SBATCH --gres=gpu:2|#SBATCH --gres=gpu:$GPU_COUNT|g" \
      -e "s|#SBATCH --partition=dgx|#SBATCH --partition=$PARTITION|g" \
      -e "s|#SBATCH --mem=32G|#SBATCH --mem=$MEMORY|g" \
      -e "s|source .env|source ./experiments/$JOB_ID/$ENV_FILE|g" \
      -e "s|--volume ../outputLogs:/home/user/app/outputLogs/|--volume ./experiments/$JOB_ID/outputLogs:/home/user/app/outputLogs/|g" \
      base_contract_docker.slurm > $TMP_SCRIPT
else
  sed -e "s|#SBATCH --output=%j.out|#SBATCH --output=./experiments/$JOB_ID/%j.out|g" \
      -e "s|#SBATCH --error=%j.err|#SBATCH --error=./experiments/$JOB_ID/%j.err|g" \
      -e "s|#SBATCH --gres=gpu:2|#SBATCH --gres=gpu:$GPU_COUNT|g" \
      -e "s|#SBATCH --partition=dgx|#SBATCH --partition=$PARTITION|g" \
      -e "s|#SBATCH --mem=32G|#SBATCH --mem=$MEMORY|g" \
      -e "s|source .env|source ./experiments/$JOB_ID/$ENV_FILE|g" \
      base_contract_conda_hpc.slurm > $TMP_SCRIPT
fi

# If QoS was specified, insert an SBATCH qos line after the partition line
if [ -n "$QOS" ]; then
  echo "Applying QoS: $QOS to SLURM script"
  sed -i "/#SBATCH --partition=$PARTITION/a #SBATCH --qos=$QOS" $TMP_SCRIPT
fi

# If time limit was specified, insert an SBATCH time line after the mem line
if [ -n "$TIME" ]; then
  echo "Applying time limit: $TIME to SLURM script"
  if grep -q "^#SBATCH --time=" "$TMP_SCRIPT"; then
    sed -i "s|^#SBATCH --time=.*|#SBATCH --time=$TIME|" "$TMP_SCRIPT"
  else
    sed -i "/#SBATCH --mem=$MEMORY/a #SBATCH --time=$TIME" "$TMP_SCRIPT"
  fi
fi

# Make it executable
chmod +x $TMP_SCRIPT
mv ./$TMP_SCRIPT ./experiments/$JOB_ID


echo "SLURM script: ./experiments/$JOB_ID/$TMP_SCRIPT"
echo "Environment file: ./experiments/$JOB_ID/$ENV_FILE"

# Submitting the 
echo "##################################"
sbatch ./experiments/$JOB_ID/$TMP_SCRIPT