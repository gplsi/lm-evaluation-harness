#!/bin/bash

# Check if correct number of arguments are passed
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <model_route> <output_folder>"
    exit 1
fi

# Assign the arguments to variables
MODEL_ROUTE=$1
echo MODEL_ROUTE
OUTPUT_SUBFOLDER=$2
WANDB=$3

# Define the main output logs directory
OUTPUT_MAIN_DIR="outputLogs"

# Create the subfolder inside outputLogs if it doesn't exist
mkdir -p "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER"

# Spanish commands
echo "Executing Spanish commands..."
# ./execute_task_love.sh "$MODEL_ROUTE" belebele_spa_Latn,wnli_es,xnli_es,xstorycloze_es,xquad_es 5 False $WANDB > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/1_Spanish.txt" 2>&1 || true
# ./execute_task_love.sh "$MODEL_ROUTE" paws_es,mgsm_direct_es_v2,phrases_es,cocoteros_es,xlsum_es 5 False $WANDB > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/2_Spanish.txt" 2>&1 || true
# ./execute_task_love.sh "$MODEL_ROUTE" flores_es 5 False $WANDB > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/3_Spanish.txt" 2>&1 || true

# Catalan commands
# echo "Executing Catalan commands..."
# ./execute_task_love.sh "$MODEL_ROUTE" belebele_cat_Latn,xnli_ca,xnli_va,catcola,copa_ca,openbookqa_ca 5 False $WANDB > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/1_Catalan.txt" 2>&1 || true
# ./execute_task_love.sh "$MODEL_ROUTE" paws_ca,piqa_ca,siqa_ca,teca,wnli_ca,arc_ca_easy,arc_ca_challenge,xstorycloze_ca 5 False $WANDB > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/2_Catalan.txt" 2>&1 || true
# ./execute_task_love.sh "$MODEL_ROUTE" catalanqa,mgsm_direct_ca,phrases_va 5 False $WANDB > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/3_Catalan.txt" 2>&1 || true
# ./execute_task_love.sh "$MODEL_ROUTE" flores_ca 5 False $WANDB > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/4_Catalan.txt" 2>&1 || true


# English commands
echo "Executing English commands..."
./execute_task_love.sh "$MODEL_ROUTE" mgsm_direct_en,xstorycloze_en,xnli_en,triviaqa,paws_en,belebele_eng_Latn 5 False $WANDB > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/1_English.txt" 2>&1 || true
# ./execute_task_love.sh "$MODEL_ROUTE" mgsm_direct_en,triviaqa,paws_en,belebele_eng_Latn 5 False $WANDB > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/2_English.txt" 2>&1 || true
echo "All commands executed."
