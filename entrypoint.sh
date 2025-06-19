#!/bin/bash
# AUTENTICATE IN WANDB 
#wandb login $WANDB_API_KEY  # Authenticate W&B
#PARSE STRING MODELS
IFS=',' read -r -a arr_models <<< $MODELS_TO_EVALUATE

#Loop in order to evaluate a list of models
for model in "${arr_models[@]}"; do
    echo "Evaluating $model"
    echo "./launch_scripts/execAllScripts.sh" $model $WANDB_PROJECT $INSTRUCT_EVALUATION
    ./launch_scripts/execAllScripts_conda.sh $model $WANDB_PROJECT $INSTRUCT_EVALUATION
done


python3 -m launch_scripts.format_results --evaluation_folder $EVALUATION_FOLDER --evaluation_folder_gold $EVALUATION_FOLDER_GOLD
