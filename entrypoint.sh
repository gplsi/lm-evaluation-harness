#!/bin/bash
# UNPROTECT VOLUME
chmod 777 -R /app
chmod 777 -R /outputLogs

# AUTENTICATE IN WANDB 
wandb login $WANDB_API_KEY  # Authenticate W&B

# Run tasks sequentially
./execAllScripts.sh $MODEL_ID_HUGGING_FACE  $WANDB_PROJECT
python3 format_results.py

