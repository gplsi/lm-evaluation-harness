#!/bin/bash
#PBS -N "_19-04-2024"
#PBS -A "tpc"
#PBS -o ../logs/_19-04-2024.out
#PBS -e ../logs/_19-04-2024.err
#PBS -V
#PBS -l select=1:system=polaris:ngpus=2
#PBS -l filesystems=home:eagle
#PBS -l walltime=0:30:00
#PBS -q debug


# Change to working directory
cd ${PBS_O_WORKDIR}

module load singularity
module load cudatoolkit-standalone/12.0.0

echo "START TIME: "$(date)
# print the first 10 lines of this script to save sbatch requirements
head -n 10 "$0"

singularity exec --nv -B /eagle:/eagle -B /lus:/lus ../../nemo_2311 bash -c "
    bash /eagle/projects/tpc/bsc/nemo/lm-evaluation-harness/launch_scripts/execute_task.sh $model $dataset $num_fewshot $tensor_parallelism"
#     bash /eagle/projects/tpc/bsc/lm-evaluation-harness/launch_scripts/polaris/execute_task_cesga.sh $model $dataset $num_fewshot $PBS_JOBID"

echo "END TIME: "$(date) 
