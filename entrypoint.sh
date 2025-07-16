#!/bin/bash
# AUTENTICATE IN WANDB 
#wandb login $WANDB_API_KEY  # Authenticate W&B
#PARSE STRING MODELS
IFS=',' read -r -a arr_models <<< $MODELS_TO_EVALUATE

umask 007

if $MODELS_FOLDER; then
    model_dir=$MODELS_FOLDER/$model
else
    model_dir=$model
fi

#Loop in order to evaluate a list of models
for model in "${arr_models[@]}"; do
    echo "Evaluating $model"
    if [-n "$MODELS_FOLDER" ]; then
        model_dir=$MODELS_FOLDER/$model
    else
        model_dir=$model
    fi
    echo "./launch_scripts/execAllScripts.sh" $model_dir $WANDB_PROJECT $INSTRUCT_EVALUATION
    ./launch_scripts/execAllScripts.sh $model_dir $WANDB_PROJECT $INSTRUCT_EVALUATION
done


python3 -m launch_scripts.format_results --evaluation_folder $EVALUATION_FOLDER --evaluation_folder_gold $EVALUATION_FOLDER_GOLD
