#!/bin/bash
#SBATCH --job-name=llm_evaluation_harness          # Nombre del trabajo
#SBATCH --output=%j.out         # Nombre del archivo de salida
#SBATCH --error=%j.err          # Nombre del archivo de error
#SBATCH --cpus-per-task=32             # Número de CPUs por tarea
#SBATCH --mem=64G                      # Memoria por nodo
#SBATCH --partition=dgx           # Cola (partición) a la que enviar el trabajo
#SBATCH --gres=gpu:2


# Cargar variables de entorno desde el archivo .env
set -a
source .env
set +a


# Aquí empieza la sección de comandos que se van a ejecutar

echo "Iniciando trabajo en `hostname` a las `date` $SLURM_IDX"
nombrecont=$SLURM_JOBID"_nombrecont"
echo $nombrecont
echo "CUDA_VISIBLE_DEVICES: $CUDA_VISIBLE_DEVICES"
nvidia-smi
R=`pwd`
# Ejecuta tu programa aquí (reemplaza esto con lo que desees ejecutar)
# Ejecutar el contenedor con acceso a la GPU
#echo "Building lm-evaluation-harness Docker image..."
#docker build --network=host --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) -t lm-evaluation-harness .
echo "Running lm-evaluation-harness Docker container..."
docker run --rm \
  --gpus device=$CUDA_VISIBLE_DEVICES  \
  --network host \
  --env NVIDIA_DRIVER_CAPABILITIES=compute,utility \
  --env WANDB_API_KEY="${WANDB_API_KEY}" \
  --env MODELS_TO_EVALUATE="${MODELS_TO_EVALUATE}" \
  --env HF_TOKEN="${HF_TOKEN}" \
  --env WANDB_PROJECT="${WANDB_PROJECT}" \
  --env USER_ID="${USER_ID}" \
  --env GROUP_ID="${GROUP_ID}" \
  --env INSTRUCT_EVALUATION="${INSTRUCT_EVALUATION}" \
  --volume /home/gplsi/GPLSI/evaluaciones/gemma-3-1b/reports:/app/reports \
  --volume /home/gplsi/GPLSI/evaluaciones/gemma-3-1b/results:/app/results \
  --volume ./outputLogs:/outputLogs \
  --name gplsi_lm-evaluation-harness \
  lm-evaluation-harness

echo "Trabajo finalizado a las `date`"
