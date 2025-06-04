#!/bin/bash
## SCRIPT TO EXECUTE CUSTOM TASKS
# Check if correct number of arguments are passed
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <model_route> <WANDB> <INSTRUCT>"
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
echo $INSTRUCT
# Define the main output logs directory
OUTPUT_MAIN_DIR="/outputLogs"

# Create the subfolder inside outputLogs if it doesn't exist
echo "Directory created: $OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER"
mkdir -p "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER"
echo o

## Valencian commands
echo "Executing EVALUATION commands..."
yes | ./execute_task_love.sh "$MODEL_ROUTE" cocoteros_es 5 False $WANDB gemma_evaluation $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/Cocoteros.txt" 2>&1  || true
yes | ./execute_task_love.sh "$MODEL_ROUTE" piqa_eu 0 False $WANDB gemma_evaluation $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/piqa_eu.txt" 2>&1 || true


echo "All commands executed."