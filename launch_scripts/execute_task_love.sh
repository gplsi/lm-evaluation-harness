#!/bin/bash              
cd ../ 
          
export HF_HOME=./cache
#export SINGULARITY_CACHEDIR=./cache_singularity
#export SINGULARITY_TMPDIR=./cache_singularity
export TORCHDYNAMO_SUPPRESS_ERRORS=True
          
model=$1  
dataset=$2                                                                                                                                                                                                     
few_shot=$3
tensor_parallelism=$4
wandb=$5

if [ "$computer" == "polaris" ]; then
    job_id=$PBS_JOBID
else
    # job_id=$SLURM_JOB_ID
    job_id=$RANDOM
fi          

# output_dir=results/$(basename ${model})/results:$(basename ${model}):${dataset}:${few_shot}-shot_${job_id}.json
output_dir=results/$(basename ${model})/results:$(basename ${model}):${dataset}:${few_shot}-shot_${job_id}.json

cuda_device_count=$(python -c "import torch; print(torch.cuda.device_count())")
echo "Available GPUs: $cuda_device_count"

if [[ $model == *".nemo"* ]]; then
    # If it contains ".nemo", do the following
    echo "The model name contains '.nemo'."
    if [ $((cuda_device_count)) =< 1]; then
        lm_eval --model nemo_lm \
            --model_args path=$model \
            --tasks ${dataset} \
            --num_fewshot $few_shot \
            --batch_size 1 \
            --output_path $output_dir \
            --log_samples \
            --seed 1234
    else
        if [ "${tensor_parallelism}" == "True" ]; then
            torchrun --nproc-per-node=$((cuda_device_count)) lm_eval \
                --model nemo_lm \
                --model_args path=$model,devices=$((cuda_device_count)),tensor_model_parallel_size=$((cuda_device_count)) \
                --tasks ${dataset} \
                --num_fewshot $few_shot \
                --batch_size 1 \                                        
                --output_path $output_dir \
                --log_samples \
                --seed 1234
        else
            torchrun --nproc-per-node=$((cuda_device_count)) lm_eval \
                --model nemo_lm \
                --model_args path=$model,devices=$((cuda_device_count)) \
                --tasks ${dataset} \
                --num_fewshot $few_shot \
                --batch_size 1 \
                --output_path $output_dir \
                --log_samples \
                --seed 1234
        fi
    fi
else
    # If it doesn't contain ".nemo", assume it is hf
    echo "The model name does not contain '.nemo'."
    if [ "${tensor_parallelism}" == "True" ]; then        
        python -m lm_eval --model hf \
            --model_args pretrained=$model,trust_remote_code=True,parallelize=True \
            --tasks ${dataset} \
            --num_fewshot $few_shot \
            --batch_size 1 \
            --output_path $output_dir \
            --log_samples \
            --seed 1234
    else        
        accelerate launch -m lm_eval --model hf \
            --model_args pretrained=$model,trust_remote_code=True \
            --tasks ${dataset} \
            --num_fewshot $few_shot \
            --batch_size 1 \
            --output_path $output_dir \
            --log_samples \
            --seed 1234 \
            --wandb_args project=$wandb,entity=gplsi_continual
    fi
fi


