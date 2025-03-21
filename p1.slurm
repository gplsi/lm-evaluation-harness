#!/bin/bash
#SBATCH --job-name=llm_evaluation_harness          # Nombre del trabajo
#SBATCH --output=%j.out         # Nombre del archivo de salida
#SBATCH --error=%j.err          # Nombre del archivo de error
#SBATCH --cpus-per-task=1             # Número de CPUs por tarea
#SBATCH --mem=1G                      # Memoria por nodo
#SBATCH --partition=titan           # Cola (partición) a la que enviar el trabajo
#SBATCH --gres=gpu:2
#SBATCH --gres=shard:24


# Aquí empieza la sección de comandos que se van a ejecutar

echo "Iniciando trabajo en `hostname` a las `date` $SLURM_IDX"
nombrecont=$SLURM_JOBID"_nombrecont"
echo $nombrecont
nvidia-smi
R=`pwd`
# Ejecuta tu programa aquí (reemplaza esto con lo que desees ejecutar)
# Ejecutar el contenedor con acceso a la GPU
docker build --network=host --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) -t lm-evaluation-harness .
#docker run --gpus device=$SLURM_IDX --name $nombrecont --rm -v $R:/workspace pytorch-train python train_minist.py
docker compose up 
echo "Trabajo finalizado a las `date`"