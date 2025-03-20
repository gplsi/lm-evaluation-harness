#!/bin/bash
#SBATCH --job-name="_14-05-2024"
#SBATCH -D .
#SBATCH --output=../logs/%x_%j.out
#SBATCH --error=../logs/%x_%j.err
#SBATCH --gres=gpu:a100:2
#SBATCH --cpus-per-task=64
#SBATCH --nodes 1
#SBATCH --mem=128G
#SBATCH -t 09:00:00


model=$1
dataset=$2
few_shot=$3
tensor_parallelism=$4

module load singularity

echo "START TIME: "$(date)
# print the first 10 lines of this script to save sbatch requirements
head -n 10 "$0"

singularity exec --nv ../../nemo_2311 bash -c "
    bash execute_task.sh $model $dataset $few_shot $tensor_parallelism"

echo "END TIME: "$(date)
