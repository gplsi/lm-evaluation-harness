MODEL_ROUTE=$1
SHOTS=$2
WANDB=$3
INSTRUCT=$4
OUTPUT_MAIN_DIR=$5
OUTPUT_SUBFOLDER=$6



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