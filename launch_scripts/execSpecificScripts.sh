#!/bin/bash


# This script is used for running specific benchmarks, if you want to run all the benchmarks,
# use execAllScripts.sh or execAllScriptsSeveralModels.sh for running several models at once.

# Check if correct number of arguments are passed
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <model_route> <output_folder>"
    exit 1
fi

# Assign the arguments to variables
MODEL_ROUTE=$1
SCRIPTS=$2
echo MODEL_ROUTE
OUTPUT_SUBFOLDER=$3
WANDB=$4

# Define the main output logs directory
OUTPUT_MAIN_DIR="outputLogs"

# Create the subfolder inside outputLogs if it doesn't exist
mkdir -p "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER"

# Spanish commands
echo "Executing commands..."
./execute_task_love.sh "$MODEL_ROUTE" "$SCRIPTS" 5 False $WANDB > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/benchmarks.txt" 2>&1 || true
echo "All commands executed."
