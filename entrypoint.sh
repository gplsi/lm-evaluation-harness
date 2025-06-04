#!/bin/bash
# AUTENTICATE IN WANDB 
#wandb login $WANDB_API_KEY  # Authenticate W&B
#PARSE STRING MODELS
IFS=',' read -r -a arr_models <<< $MODELS_TO_EVALUATE

#Loop in order to evaluate a list of models
for model in "${arr_models[@]}"; do
    echo "Evaluating $model"
    echo "./execAllScripts.sh" $model $WANDB_PROJECT $INSTRUCT_EVALUATION
    ./execAllScripts.sh $model $WANDB_PROJECT $INSTRUCT_EVALUATION
done


python3 format_results.py
