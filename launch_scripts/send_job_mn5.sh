#!/bin/bash                                                                                                                                                                                                        
#SBATCH --job-name="_01-07-2024"
#SBATCH -D .             
#SBATCH --output=../logs/%x_%j.out  
#SBATCH --error=../logs/%x_%j.err  
#SBATCH --gres=gpu:4
#SBATCH --cpus-per-task=80
#SBATCH --nodes 1
#SBATCH -t 2-00:00:00
#SBATCH --qos acc_bscls
#SBATCH --account bsc88
 
model=$1    
dataset=$2    
few_shot=$3    
tensor_parallelism=$4   
     
module load singularity 

START=$(date +%s);

echo "START TIME: "$(date)
# print the first 10 lines of this script to save sbatch requirements
head -n 10 "$0"    
     
singularity exec --nv ../../nemo_2311 bash -c "bash execute_task.sh $model $dataset $few_shot $tensor_parallelism"

END=$(date +%s); 

echo "END TIME: "$(date)  
echo "JOB DURATION: $(echo $((END-START)) | awk '{print int($1/60)":"int($1%60)}')"

