#!/bin/bash
#SBATCH --job-name=llm_evaluation_harness
#SBATCH --output=%j.out
#SBATCH --error=%j.err          
#SBATCH --cpus-per-task=32
#SBATCH --mem=32G                      
#SBATCH --partition=dgx          
#SBATCH --gres=gpu:2

# Activar entorno
source ~/anaconda3/etc/profile.d/conda.sh
conda activate hardness
nvidia-smi

# Cargar variables de entorno desde .env
set -a
source .env
set +a


huggingface-cli login --token $HF_TOKEN

../../entrypoint.sh