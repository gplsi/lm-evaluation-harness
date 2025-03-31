#!/bin/bash

# Check if correct number of arguments are passed
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <model_route> <output_folder>"
    exit 1
fi

# Assign the arguments to variables
MODEL_ROUTE=$1
echo $MODEL_ROUTE
TIMESTAMP=$(date +'%Y%m%d_%H%M%S')
OUTPUT_SUBFOLDER=$(echo "$MODEL_ROUTE" | tr '/' '_')
OUTPUT_SUBFOLDER="${OUTPUT_SUBFOLDER}_${TIMESTAMP}"
WANDB=$2

# Define the main output logs directory
OUTPUT_MAIN_DIR="/outputLogs"

# Create the subfolder inside outputLogs if it doesn't exist
echo "Directory created: $OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER"
mkdir -p "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER"
echo o

# Valencian commands
echo "Executing Valencian commands..."
yes | ./execute_task_love.sh "$MODEL_ROUTE" cocoteros_va 5 False $WANDB 1_Valencian > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/1_Valencian.txt" 2>&1  || true

# Spanish commands
echo "Executing Spanish commands..."
yes | ./execute_task_love.sh "$MODEL_ROUTE" belebele_spa_Latn,wnli_es,xnli_es,xstorycloze_es,xquad_es 5 False $WANDB 1_Spanish > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/1_Spanish.txt" 2>&1  || true
yes | ./execute_task_love.sh "$MODEL_ROUTE" paws_es_spanish_bench,mgsm_direct_es_spanish_bench,phrases_es,cocoteros_es,xlsum_es 5 False $WANDB 2_Spanish > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/2_Spanish.txt" 2>&1 || true
yes | ./execute_task_love.sh "$MODEL_ROUTE" flores_es 5 False $WANDB 3_Spanish >  "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/3_Spanish.txt"  2>&1  || true
yes | ./execute_task_love.sh "$MODEL_ROUTE" phrases_va-es 5 False $WANDB 4_Spanish >  "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/4_Spanish.txt" 2>&1 || true
#
## Catalan commands
echo "Executing Catalan commands..."
yes | ./execute_task_love.sh "$MODEL_ROUTE" belebele_cat_Latn,xnli_ca,xnli_va,catcola,copa_ca,openbookqa_ca 5 False $WANDB 1_Catalan > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/1_Catalan.txt"  2>&1 || true
yes | ./execute_task_love.sh "$MODEL_ROUTE" paws_ca,piqa_ca,siqa_ca,teca,wnli_ca,arc_ca_easy,arc_ca_challenge,xstorycloze_ca 5 False $WANDB 2_Catalan > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/2_Catalan.txt" 2>&1 || true
yes | ./execute_task_love.sh "$MODEL_ROUTE" catalanqa,mgsm_direct_ca,phrases_va 5 False $WANDB 3_Catalan > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/3_Catalan.txt" 2>&1 || true
yes | ./execute_task_love.sh "$MODEL_ROUTE" flores_ca 5 False $WANDB > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/4_Catalan.txt" 2>&1 || true
#
##
##
### English commands
echo "Executing English commands..."
yes | ./execute_task_love.sh "$MODEL_ROUTE" xstorycloze_en,xnli_en,triviaqa,paws_en,belebele_eng_Latn 5 False $WANDB 1_English > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/1_English.txt" 2>&1 || true
yes | ./execute_task_love.sh "$MODEL_ROUTE" piqa,mgsm_direct_en 5 False 2_English $WANDB > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/2_English.txt" 2>&1 || true
yes | ./execute_task_love.sh "$MODEL_ROUTE" coqa 5 False $WANDB 3_English > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/3_English.txt" 2>&1 || true
#
echo "All commands executed."
