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
        ### Valencian commands
        echo "Executing Valencian commands..."
        yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" cocoteros_va $SHOTS False $WANDB 1_Valencian $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/1_Valencian.txt" 2>&1  || true
        yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" xnli_va $SHOTS False $WANDB 2_Valencian $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/2_Valencian.txt" 2>&1 || true
    
    fi
    if [[ "$language" == "es" ]]; then
        ## Spanish commands
        echo "Executing Spanish commands..."
        #
        yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" belebele_spa_Latn,wnli_es,xnli_es,xstorycloze_es,xquad_es $SHOTS False $WANDB 1_Spanish $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/1_Spanish.txt" 2>&1  || true
        #
        yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" paws_es_spanish_bench,mgsm_direct_es_spanish_bench,phrases_es,cocoteros_es,xlsum_es $SHOTS False $WANDB 2_Spanish $INSTRUCT  > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/2_Spanish.txt" 2>&1 || true

        ##yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" flores_es $SHOTS False $WANDB 3_Spanish $INSTRUCT >  "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/3_Spanish.txt"  2>&1  || true

        yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" escola,openbookqa_es,xquad_es $SHOTS False $WANDB 3_Spanish $INSTRUCT  >  "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/3_Spanish.txt" 2>&1 || true

        #yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" copa_es $SHOTS False $WANDB 4_Spanish $INSTRUCT  >  "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/4_Spanish.txt" 2>&1 || true
    fi
    if [[ "$language" == "ca" ]]; then
        ### Catalan commands

        echo "Executing Catalan commands..."
        yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" belebele_cat_Latn,xnli_ca,catcola,copa_ca,openbookqa_ca $SHOTS False $WANDB 1_Catalan $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/1_Catalan.txt"  2>&1 || true

        yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" paws_ca,piqa_ca,siqa_ca,teca,wnli_ca,arc_ca_easy,arc_ca_challenge,xstorycloze_ca $SHOTS False $WANDB 2_Catalan $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/2_Catalan.txt" 2>&1 || true

        yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" catalanqa,mgsm_direct_ca,phrases_va $SHOTS False $WANDB 3_Catalan $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/3_Catalan.txt" 2>&1 || true
        #yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" flores_ca $SHOTS False $WANDB > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/4_Catalan.txt" 2>&1 || true

        yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" xquad_ca $SHOTS False $WANDB 4_Catalan $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/4_Catalan.txt" 2>&1 || true

        yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" cabreu $SHOTS False $WANDB $SHOTS_Catalan $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/5_Catalan.txt" 2>&1 || true

        yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" catalanqa $SHOTS False $WANDB 6_Catalan $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/6_Catalan.txt" 2>&1 || true

        #yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" parafraseja $SHOTS False $WANDB 7_Catalan $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/7_Catalan.txt" 2>&1 || true
    fi

    if [[ "$language" == "en" ]]; then
        #### English commands
        echo "Executing English commands..."

        yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" xstorycloze_en,xnli_en,triviaqa,paws_en,belebele_eng_Latn $SHOTS False $WANDB 1_English $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/1_English.txt" 2>&1 || true

        yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" coqa $SHOTS False $WANDB 2_English $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/2_English.txt" 2>&1 || true

        yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" piqa $SHOTS False $WANDB 3_English $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/3_English.txt" 2>&1 || true

        yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" mgsm_direct_en $SHOTS False $WANDB 4_English $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/4_English.txt" 2>&1 || true

        yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" cola $SHOTS False $WANDB $SHOTS_English $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/5_English.txt" 2>&1 || true

        yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" wnli $SHOTS False $WANDB 6_English $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/6_English.txt" 2>&1 || true

        yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" openbookqa $SHOTS False $WANDB 7_English $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/7_English.txt" 2>&1 || true

        yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" arc_easy $SHOTS False $WANDB 8_English $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/8_English.txt" 2>&1 || true

        yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" arc_challenge $SHOTS False $WANDB 9_English $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/9_English.txt" 2>&1 || true

        yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" social_iqa $SHOTS False $WANDB 10_English $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/10_English.txt" 2>&1 || true

    fi

    #### Galician commands
    #echo "Executing Galician commands..."
    #
    #yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" xstorycloze_gl,xnli_gl,paws_gl,belebele_glg_Latn $SHOTS False $WANDB 1_Galician $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/1_English.txt" 2>&1 || true
    #
    #yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" mgsm_direct_gl $SHOTS False $WANDB 2_Galician $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/2_Galician.txt" 2>&1 || true
    #
    #yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" galcola $SHOTS False $WANDB 3_Galician $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/3_Galician.txt" 2>&1 || true
    #
    #yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" openbookqa_gl $SHOTS False $WANDB 4_Galician $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/4_Galician.txt" 2>&1 || true
    #
    #yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" truthfulqa_gl $SHOTS False $WANDB $SHOTS_Galician $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/$SHOTS_Galician.txt" 2>&1 || true
    #
    #yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" parafrases_gl $SHOTS False $WANDB 6_Galician $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/6_Galician.txt" 2>&1 || true
    #
    #yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" xnli_gl $SHOTS False $WANDB 7_Galician $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/7_Galician.txt" 2>&1 || true
    #
    #yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" summarization_gl $SHOTS False $WANDB 8_Galician $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/8_Galician.txt" 2>&1 || true
done
    echo "All commands executed."