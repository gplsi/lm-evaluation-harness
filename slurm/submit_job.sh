#!/bin/bash

CONFIG_FILE=""
DOCKER_MODE=false

# Parse options: c requires an argument, d is a flag without argument
while getopts ":c:d" opt; do
  case $opt in
    c)
      CONFIG_FILE="$OPTARG"
      ;;
    d)
      DOCKER_MODE=true
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
  echo "Usage: $0 -c <config_file.yaml> [-d]"
  exit 1
fi


# Generate unique ID for this job
JOB_ID=$(date +%Y%m%d_%H%M%S)_$$  # timestamp + process ID
# Alternative: JOB_ID=$(uuidgen | cut -d- -f1)  # first part of UUID

echo "Job ID: $JOB_ID"

if [ "$DOCKER_MODE" = true ]; then
  echo "Generating environment file from config: $CONFIG_FILE and to be used in DOCKER mode"
  python3 generate_env.sh --config "$CONFIG_FILE" --env-id "$JOB_ID" --docker
else
  # Generate environment file using generate_env.sh with custom ID
  echo "Generating environment file from config: $CONFIG_FILE and to be used in CONDA mode"
  python3 generate_env.sh --config "$CONFIG_FILE" --env-id "$JOB_ID"
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

# Create a temporary SLURM script with the correct env file
TMP_SCRIPT="slurm_job_${JOB_ID}.slurm"

# Copy the base contract and replace the env source line
sed -e "s|#SBATCH --output=%j.out|#SBATCH --output=./experiments/$JOB_ID/%j.out|g" \
    -e "s|#SBATCH --error=%j.err|#SBATCH --error=./experiments/$JOB_ID/%j.err|g" \
    -e "s|source .env|source ./experiments/$JOB_ID/$ENV_FILE|g" \
    -e "s|--volume ../outputLogs:/home/user/app/outputLogs/|--volume ./experiments/$JOB_ID/outputLogs:/home/user/app/outputLogs/|g" \
    base_contract.slurm > $TMP_SCRIPT


# Make it executable
chmod +x $TMP_SCRIPT
mv ./$TMP_SCRIPT ./experiments/$JOB_ID


echo "SLURM script: ./experiments/$JOB_ID/$TMP_SCRIPT"
echo "Environment file: ./experiments/$JOB_ID/$ENV_FILE"

# Submitting the 
echo "##################################"
sbatch ./experiments/$JOB_ID/$TMP_SCRIPT