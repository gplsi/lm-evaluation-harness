#!/bin/bash

wandb login $WANDB_API_KEY  # Authenticate W&B

# Run tasks sequentially
#./execAllScripts.sh $MODEL_ID_HUGGING_FACE  $WANDB_PROJECT
python3 format_results.py

# Keep the container alive
exec "$@"
