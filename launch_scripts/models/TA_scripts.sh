MODEL_ROUTE=$1
SHOTS=$2
WANDB=$3
INSTRUCT=$4
OUTPUT_MAIN_DIR=$5
OUTPUT_SUBFOLDER=$6



echo "Executing TA commands..."
yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" phrases_es,phrases_va $SHOTS False $WANDB 1_TA $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/1_TA.txt" 2>&1 || true
yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" flores_ca $SHOTS False $WANDB 2_TA $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/2_TA.txt" 2>&1 || true

yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" flores_es $SHOTS False $WANDB 3_TA $INSTRUCT >  "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/3_TA.txt"  2>&1  || true


