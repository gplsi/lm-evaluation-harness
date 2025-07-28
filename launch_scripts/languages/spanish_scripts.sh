MODEL_ROUTE=$1
SHOTS=$2
WANDB=$3
INSTRUCT=$4
OUTPUT_MAIN_DIR=$5
OUTPUT_SUBFOLDER=$6



## Spanish commands
echo "Executing Spanish commands..."
#
yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" belebele_spa_Latn,wnli_es,xnli_es,xstorycloze_es,xquad_es $SHOTS False $WANDB 1_Spanish $INSTRUCT > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/1_Spanish.txt" 2>&1  || true
#
yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" paws_es_spanish_bench,mgsm_direct_es_spanish_bench,phrases_es,cocoteros_es,xlsum_es $SHOTS False $WANDB 2_Spanish $INSTRUCT  > "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/2_Spanish.txt" 2>&1 || true

##yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" flores_es $SHOTS False $WANDB 3_Spanish $INSTRUCT >  "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/3_Spanish.txt"  2>&1  || true

yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" escola,openbookqa_es,xquad_es $SHOTS False $WANDB 3_Spanish $INSTRUCT  >  "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/3_Spanish.txt" 2>&1 || true

#yes | ./launch_scripts/execute_task_love.sh "$MODEL_ROUTE" copa_es $SHOTS False $WANDB 4_Spanish $INSTRUCT  >  "$OUTPUT_MAIN_DIR/$OUTPUT_SUBFOLDER/4_Spanish.txt" 2>&1 || true