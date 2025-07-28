#!/bin/bash
#SBATCH --job-name=lm_hardness-hf
#SBATCH --output=%j.out         # Nombre del archivo de salida
#SBATCH --error=%j.err          # Nombre del archivo de error
#SBATCH --partition=dgx
#SBATCH --gres=gpu:2
#SBATCH --mem=32GB
#SBATCH --nodes=1
#SBATCH --cpus-per-task=64
#SBATCH --time=48:00:00

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