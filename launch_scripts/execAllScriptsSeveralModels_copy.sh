#!/bin/bash

# List of models with their paths
models=(
  "epoch_1"
)

# Base paths
base_dir="/workspace/NAS/LLAMA/modelos/llama3-8B-valenciano"
results_dir="/workspace/results"
script_dir="$(dirname "$0")"  # The directory where the script is located
logs_dir="${script_dir}/outputLogs"  # Logs directory
wandb="LLAMA_3.0_8B_valenciano_eng_mikel"

echo "BASE DIR: $base_dir"
echo "RESULTS DIR: $results_dir"
echo "SCRIPT DIR: $script_dir"
echo "LOGS DIR: $logs_dir"

# Loop over each model
for model_path in "${models[@]}"; do
  # Extract the model name (e.g., Aitana_intruction_english_v1)
  model_name=$(echo "$model_path" | cut -d'/' -f1)

  # Extract the step (e.g., step-004080-hf or final-hf)
  step=$(echo "$model_path" | cut -d'/' -f2)

  # Build the full model path
  full_model_path="${base_dir}/${model_path}"

  # Build the target directory for the results
  target_dir="${results_dir}/${step}"

  # Log file for this model
  log_file="${logs_dir}/${model_name}_${step}.log"

  #New dir
  new_dir="${results_dir}/${model_name}_${step}"

  echo "MODEL NAME: $model_name"
  echo "STEP: $step"
  echo "FULL MODEL PATH: $full_model_path"
  echo "TARGET DIR: $target_dir"
  echo "LOG FILE: $log_file"
  echo "NEW DIR: $new_dir"
  echo

  # Write header in the log file
  echo "Running script for ${model_name} - ${step} on $(date)" > "$log_file"

  # Execute the script and log both stdout and stderr to the specific model's log file
  nohup ./execAllScripts_copy.sh "$full_model_path" "${model_name}_${step}" "${wandb}" >> "$log_file" 2>&1

  # Rename the target directory to include the model name and step
  if [ -d "$target_dir" ]; then
    new_dir="${results_dir}/${model_name}_${step}"
    mv "$target_dir" "$new_dir"
  else
    echo "Directory ${target_dir} not found" >> "$log_file"
  fi

  # Log completion for this model
  echo "Finished script for ${model_name} - ${step} on $(date)" >> "$log_file"
  echo "------------------------------------------------------------" >> "$log_file"
done
