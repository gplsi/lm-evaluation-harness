
#FROM nvcr.io/nvidia/pytorch:24.02-py3
FROM nvcr.io/nvidia/pytorch:25.02-py3

# Argumentos para UID y GID
ARG USER_ID
ARG GROUP_ID


RUN apt-get update --allow-insecure-repositories && \
    apt-get install -y --allow-unauthenticated git curl wget build-essential unzip && \
    rm -rf /var/lib/apt/lists/*

# Copy application code to container
COPY . /app
WORKDIR /app

RUN pip install -e . --verbose
RUN pip uninstall pydantic -y
RUN pip install --no-cache-dir pydantic
RUN pip install wandb
RUN pip install sentencepiece

COPY entrypoint.sh /app/launch_scripts/entrypoint.sh
RUN chmod +x /app/launch_scripts/entrypoint.sh
RUN mkdir -p /app/reports
RUN mkdir -p /outputLogs

# Crear el grupo y usuario con los IDs especificados
RUN groupadd -g $GROUP_ID usergroup && \
    useradd -m -u $USER_ID -g $GROUP_ID user && \
    mkdir -p /app && \
    chown -R user:usergroup /app && \
    chown -R user:usergroup /outputLogs

WORKDIR /app/launch_scripts

CMD ["/bin/bash", "entrypoint.sh"]
#CMD ["/bin/bash"]
