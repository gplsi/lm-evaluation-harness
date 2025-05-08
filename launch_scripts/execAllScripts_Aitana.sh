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
#echo "Executing Valencian commands..."
yes | ./execute_task_love.sh "$MODEL_ROUTE" cocoteros_va,phrases_es,phrases_va 5 False $WANDB 1_Valencian > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/1_Valencian.txt" 2>&1  || true
yes | ./execute_task_love.sh "$MODEL_ROUTE" xnli_va 5 False $WANDB 2_Valencian > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/2_Valencian.txt" 2>&1  || true

# Spanish commands
echo "Executing Spanish commands..."
yes | ./execute_task_love.sh "$MODEL_ROUTE" xstorycloze_es,wnli_es,xnli_es_spanish_bench,belebele_spa_Latn,paws_es_spanish_bench,mgsm_direct_es_spanish_bench,openbookqa_es,copa_es,xlsum_es,escola,copa_es,xquad_es,cocoteros_es 5 False $WANDB 1_Spanish > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/1_Spanish.txt" 2>&1  || true


#
## Catalan commands
#xnli_va ommited
echo "Executing Catalan commands..."
yes | ./execute_task_love.sh "$MODEL_ROUTE" xstorycloze_ca,wnli_ca,xnli_ca,belebele_cat_Latn,paws_ca,mgsm_direct_ca,openbookqa_ca,catcola,copa_ca,arc_ca_easy,arc_ca_challenge,xquad_ca,piqa_ca,siqa_ca,teca 5 False $WANDB 1_Catalan > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/1_Catalan.txt"  2>&1 || true
yes | ./execute_task_love.sh "$MODEL_ROUTE" cabreu 5 False $WANDB 2_Catalan > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/2_Catalan.txt"  2>&1 || true

##
###
###
#### English commands
echo "Executing English commands..."
yes | ./execute_task_love.sh "$MODEL_ROUTE" xstorycloze_en,wnli,xnli_en,belebele_eng_Latn,paws_en,mgsm_direct_en,openbookqa,cola,arc_easy,arc_challenge,xquad_ca,piqa,social_iqa,xquad_en,triviaqa 5 False $WANDB 1_English > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/1_English.txt" 2>&1 || true
yes | ./execute_task_love.sh "$MODEL_ROUTE" coqa 5 False $WANDB 2_English > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/2_English.txt" 2>&1 || true
echo "All commands executed."
