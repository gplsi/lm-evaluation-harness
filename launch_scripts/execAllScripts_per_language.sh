#!/bin/bash

# Check if correct number of arguments are passed
if [ "$#" -ne 5 ]; then
    echo "Usage: $0 <model_route> <WANDB> <INSTRUCT> <N_SHOTS> <LANGUAGES>"
    exit 1
fi

# Assign the arguments to variables
MODEL_ROUTE=$1
echo $MODEL_ROUTE
TIMESTAMP=$(date +'%Y%m%d_%H%M%S')
OUTPUT_SUBFOLDER=$(echo "$MODEL_ROUTE" | tr '/' '_')
OUTPUT_SUBFOLDER="${OUTPUT_SUBFOLDER}_${TIMESTAMP}"
WANDB=$2
INSTRUCT=$3 # INSTRUCT="True" means that the model is instruccion-tuned and has to be evalutaed with an speciifc flag
SHOTS=$4 # Number of shots for the tasks, 0 means no shots
IFS=',' read -r -a arr_languages <<< $5 # Languages to evaluate, separated by commas stored in arr_a  


#echo $INSTRUCT

# Get current directory
current_dir=$(pwd)

echo "Current directory: $current_dir"
# Define the main output logs directory
OUTPUT_MAIN_DIR="${current_dir}/outputLogs"

# Create the subfolder inside outputLogs if it doesn't exist
echo "Directory created: $OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER"
mkdir -p "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER"

for language in "${arr_languages[@]}"; do

    if [[ "$language" == "va" ]]; then
        ./launch_scripts/languages/valencian_scripts.sh "$MODEL_ROUTE" $SHOTS $WANDB $INSTRUCT "$OUTPUT_MAIN_DIR" "$OUTPUT_SUBFOLDER"
    fi
    if [[ "$language" == "es" ]]; then
        ./launch_scripts/languages/spanish_scripts.sh "$MODEL_ROUTE" $SHOTS $WANDB $INSTRUCT "$OUTPUT_MAIN_DIR" "$OUTPUT_SUBFOLDER"
    fi
    if [[ "$language" == "ca" ]]; then
        ./launch_scripts/languages/catalan_scripts.sh "$MODEL_ROUTE" $SHOTS $WANDB $INSTRUCT "$OUTPUT_MAIN_DIR" "$OUTPUT_SUBFOLDER"
    fi

    if [[ "$language" == "en" ]]; then
       ./launch_scripts/languages/english_scripts.sh "$MODEL_ROUTE" $SHOTS $WANDB $INSTRUCT "$OUTPUT_MAIN_DIR" "$OUTPUT_SUBFOLDER"
    fi

done
    echo "All commands executed."