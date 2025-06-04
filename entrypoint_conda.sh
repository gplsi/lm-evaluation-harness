#!/bin/bash
# AUTENTICATE IN WANDB 
#wandb login $WANDB_API_KEY  # Authenticate W&B
#PARSE STRING MODELS
IFS=',' read -r -a arr_models <<< $MODELS_TO_EVALUATE

echo "Evaluating $arr_models"
#Loop in order to evaluate a list of models
for model in "${arr_models[@]}"; do
    echo "Evaluating $model"
    echo "./launch_scripts/execAllScripts_conda.sh" $model $WANDB_PROJECT $INSTRUCT_EVALUATION
    ./launch_scripts/execAllScripts_conda.sh $model $WANDB_PROJECT $INSTRUCT_EVALUATION
done


#echo "Evaluating $model"
#echo "./execCustomScripts.sh" $model $WANDB_PROJECT False
#./execCustomScripts.sh $model $WANDB_PROJECT False
#
#
#echo "Evaluating $model"
#echo "./execCustomScripts.sh" $model $WANDB_PROJECT True
#./execAllScripts.sh $model $WANDB_PROJECT True

python3 -m launch_scripts.format_results
