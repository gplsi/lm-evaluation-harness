#!/bin/bash

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

# Get current directory
current_dir=$(pwd)

echo "Current directory: $current_dir"
# Define the main output logs directory
OUTPUT_MAIN_DIR="${current_dir}/outputLogs"

# Create the subfolder inside outputLogs if it doesn't exist
echo "Directory created: $OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER"
mkdir -p "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER"
echo o

## Valencian commands
echo "Executing Valencian commands..."
yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" cocoteros_va 5 False $WANDB 1_Valencian $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/1_Valencian.txt" 2>&1  || true

yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" xnli_va 5 False $WANDB 2_Valencian $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/2_Valencian.txt" 2>&1 || true
# Spanish commands
echo "Executing Spanish commands..."

yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" belebele_spa_Latn,wnli_es,xnli_es,xstorycloze_es,xquad_es 5 False $WANDB 1_Spanish $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/1_Spanish.txt" 2>&1  || true

yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" paws_es_spanish_bench,mgsm_direct_es_spanish_bench,phrases_es,cocoteros_es,xlsum_es 5 False $WANDB 2_Spanish $INSTRUCT  > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/2_Spanish.txt" 2>&1 || true

#yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" flores_es 5 False $WANDB 3_Spanish $INSTRUCT >  "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/3_Spanish.txt"  2>&1  || true

yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" escola,openbookqa_es,xquad_es 5 False $WANDB 3_Spanish $INSTRUCT  >  "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/3_Spanish.txt" 2>&1 || true
#
## Catalan commands
#xnli_va ommited
echo "Executing Catalan commands..."
yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" belebele_cat_Latn,xnli_ca,catcola,copa_ca,openbookqa_ca 5 False $WANDB 1_Catalan $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/1_Catalan.txt"  2>&1 || true

yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" paws_ca,piqa_ca,siqa_ca,teca,wnli_ca,arc_ca_easy,arc_ca_challenge,xstorycloze_ca 5 False $WANDB 2_Catalan $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/2_Catalan.txt" 2>&1 || true

yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" catalanqa,mgsm_direct_ca,phrases_va 5 False $WANDB 3_Catalan $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/3_Catalan.txt" 2>&1 || true
#yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" flores_ca 5 False $WANDB > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/4_Catalan.txt" 2>&1 || true

yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" xquad_ca 5 False $WANDB 4_Catalan $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/4_Catalan.txt" 2>&1 || true

yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" cabreu 5 False $WANDB 5_Catalan $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/5_Catalan.txt" 2>&1 || true

yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" catalanqa 5 False $WANDB 6_Catalan $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/6_Catalan.txt" 2>&1 || true


#### English commands
echo "Executing English commands..."

yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" xstorycloze_en,xnli_en,triviaqa,paws_en,belebele_eng_Latn 5 False $WANDB 1_English $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/1_English.txt" 2>&1 || true

yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" coqa 5 False $WANDB 2_English $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/2_English.txt" 2>&1 || true

yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" piqa 5 False $WANDB 3_English $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/3_English.txt" 2>&1 || true

yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" mgsm_direct_en 5 False $WANDB 4_English $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/4_English.txt" 2>&1 || true

yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" cola 5 False $WANDB 5_English $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/5_English.txt" 2>&1 || true

yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" wnli 5 False $WANDB 6_English $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/6_English.txt" 2>&1 || true

yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" openbookqa 5 False $WANDB 7_English $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/7_English.txt" 2>&1 || true

yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" arc_easy 5 False $WANDB 8_English $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/8_English.txt" 2>&1 || true

yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" arc_challenge 5 False $WANDB 9_English $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/9_English.txt" 2>&1 || true

yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" social_iqa 5 False $WANDB 10_English $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/10_English.txt" 2>&1 || true


#yes | ./execute_task_love.sh "$MODEL_ROUTE" flores_es 5 False $WANDB 3_Spanish >  "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/3_Spanish.txt"  2>&1  || true
#yes | ./execute_task_love.sh "$MODEL_ROUTE" flores_ca 5 False $WANDB > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/4_Catalan.txt" 2>&1 || true
echo "All commands executed."