
MODEL_ROUTE=$1
SHOTS=$2
WANDB=$3
INSTRUCT=$4
OUTPUT_MAIN_DIR=$5
OUTPUT_SUBFOLDER=$6


echo "Executing Valencian commands..."
yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" cocoteros_va $SHOTS False $WANDB 1_Valencian $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/1_Valencian.txt" 2>&1  || true
yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" xnli_va $SHOTS False $WANDB 2_Valencian $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/2_Valencian.txt" 2>&1 || true

