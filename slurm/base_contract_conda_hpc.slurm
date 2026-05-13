#!/bin/bash
#SBATCH --job-name=llm_evaluation_harness
#SBATCH --output=%j.out
#SBATCH --error=%j.err          
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G                      
#SBATCH --partition=boost_usr_prod          
#SBATCH --gres=gpu:1
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1



nvidia-smi

# Cargar variables de entorno desde .env
set -a
source .env
set +a

export HF_HOME=/leonardo_scratch/fast/EUHPC_D22_034/HF_CACHE
export HF_DATASETS_CACHE=/leonardo_scratch/fast/EUHPC_D22_034/HF_CACHE/datasets
export HF_HUB_CACHE=$HF_HOME/hub
export TRANSFORMERS_CACHE=$HF_HOME/models
export HF_DATASETS_OFFLINE=1
export HF_HUB_OFFLINE=1
huggingface-cli login --token $HF_TOKEN

cd ../

bash ./entrypoint.sh