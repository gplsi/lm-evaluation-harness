#!/bin/bash
# filepath: /home/gplsi/Documentos/ALIA/lm-evaluation-harness/launch_job.sh

# Check if env file was provided
if [ $# -ne 1 ]; then
  echo "Usage: $0 <env_file>"
  echo "Example: $0 .env_instruct_evaluation"
  exit 1
fi

ENV_FILE=$1

# Ensure the env file exists
if [ ! -f "$ENV_FILE" ]; then
  echo "Error: Environment file $ENV_FILE not found"
  exit 1
fi

# Create a temporary SLURM script with the correct env file
TMP_SCRIPT="tmp_slurm_$(basename $ENV_FILE).slurm"

# Copy the original SLURM script and replace the env source
cat p1.slurm | sed "s|source .env_v7|source $ENV_FILE|g" > $TMP_SCRIPT

# Make it executable
chmod +x $TMP_SCRIPT

# Submit the job
echo "Submitting job with environment file: $ENV_FILE"
sbatch $TMP_SCRIPT

echo "Job submitted. Temporary script created: $TMP_SCRIPT"