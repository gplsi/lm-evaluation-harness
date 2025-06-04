#!/bin/bash
#SBATCH --job-name=convert-model-hf
#SBATCH --output=%j.out         # Nombre del archivo de salida
#SBATCH --error=%j.err          # Nombre del archivo de error
#SBATCH --partition=titan
#SBATCH --gres=gpu:2
#SBATCH --mem=32G
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
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

./entrypoint_conda.sh