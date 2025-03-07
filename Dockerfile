# Base image
FROM nvcr.io/nvidia/pytorch:25.02-py3

RUN apt-get update --allow-insecure-repositories && \
    apt-get install -y --allow-unauthenticated git curl wget build-essential unzip && \
    rm -rf /var/lib/apt/lists/*

# Copy application code to container
COPY . /app
WORKDIR /app

RUN pip install -e . --verbose
RUN pip install wandb
    
COPY entrypoint.sh /app/launch_scripts/entrypoint.sh
RUN chmod +x /app/launch_scripts/entrypoint.sh 

WORKDIR /app/launch_scripts

#CMD ["/bin/bash", "entrypoint.sh"]
CMD ["/bin/bash"]


