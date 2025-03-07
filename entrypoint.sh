#!/bin/bash

wandb login $WANDB_API_KEY  # Authenticate W&B

# Run tasks sequentially
./execute_task_love.sh $MODEL_ID_HUGGING_FACE spanish_bench 5 False
./execute_task_love.sh $MODEL_ID_HUGGING_FACE catalan_bench 5 False
./execute_task_love.sh $MODEL_ID_HUGGING_FACE galician_bench 5 False
./execute_task_love.sh $MODEL_ID_HUGGING_FACE basque_bench 5 False
./execute_task_love.sh $MODEL_ID_HUGGING_FACE english_bench 5 False

# Keep the container alive
exec "$@"
