MODEL_ROUTE=$1
SHOTS=$2
WANDB=$3
INSTRUCT=$4
OUTPUT_MAIN_DIR=$5
OUTPUT_SUBFOLDER=$6
VLLM=$7



echo "Executing Catalan commands..."
yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" belebele_cat_Latn,xnli_ca $SHOTS False $WANDB 1_Catalan $INSTRUCT $VLLM > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/1_1Catalan.txt"  2>&1 || true
yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" catcola,copa_ca,openbookqa_ca $SHOTS False $WANDB 1_Catalan $INSTRUCT $VLLM > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/1_2Catalan.txt"  2>&1 || true

yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" paws_ca,piqa_ca,teca,wnli_ca,arc_ca_easy,arc_ca_challenge,xstorycloze_ca $SHOTS False $WANDB 2_Catalan $INSTRUCT $VLLM > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/2_Catalan.txt" 2>&1 || true
yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" siqa_ca $SHOTS False $WANDB 2_Catalan $INSTRUCT $VLLM > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/2_2Catalan.txt" 2>&1 || true

yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" catalanqa,mgsm_direct_ca $SHOTS False $WANDB 3_Catalan $INSTRUCT $VLLM > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/3_Catalan.txt" 2>&1 || true
#yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" flores_ca $SHOTS False $WANDB > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/4_Catalan.txt" 2>&1 || true

yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" xquad_ca $SHOTS False $WANDB 4_Catalan $INSTRUCT $VLLM > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/4_Catalan.txt" 2>&1 || true

yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" cabreu $SHOTS False $WANDB 5_Catalan $INSTRUCT $VLLM > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/5_Catalan.txt" 2>&1 || true
yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" catalanqa $SHOTS False $WANDB 6_Catalan $INSTRUCT $VLLM > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/6_Catalan.txt" 2>&1 || true

#yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" parafraseja $SHOTS False $WANDB 7_Catalan $INSTRUCT $VLLM > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/7_Catalan.txt" 2>&1 || true