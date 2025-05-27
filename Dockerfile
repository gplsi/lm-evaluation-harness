
FROM nvcr.io/nvidia/pytorch:24.02-py3
#FROM nvcr.io/nvidia/pytorch:25.01-py3

# Argumentos para UID y GID
ARG USER_ID
ARG GROUP_ID

COPY . /app
WORKDIR /app

# Crear el grupo y usuario con los IDs especificados
RUN groupadd -g $GROUP_ID usergroup && \
    useradd -m -u $USER_ID -g $GROUP_ID user && \
    mkdir -p /app && \
    mkdir -p /app/reports && \
    mkdir -p /outputLogs 
    #&& \
#    chown -R user:usergroup /app && \
#    chown -R user:usergroup /outputLogs


# RUN apt-get update --allow-insecure-repositories && \
#     apt-get install -y --allow-unauthenticated git curl wget build-essential unzip && \
#     rm -rf /var/lib/apt/lists/*


# Copy application code to container
COPY entrypoint.sh /app/launch_scripts/entrypoint.sh
RUN chmod 777 /app/launch_scripts/entrypoint.sh
RUN chmod 777 -R  /app/reports
RUN chmod 777 -R /outputLogs
#RUN mkdir -p /app/reports
#RUN mkdir -p /outputLogs



RUN pip install -e .
RUN pip uninstall pydantic -y
RUN pip install --no-cache-dir pydantic
RUN pip install wandb
RUN pip install sentencepiece
RUN pip install openpyxl
RUN apt-get install --reinstall ca-certificates
WORKDIR /app/launch_scripts

#USER user

CMD ["/bin/bash", "entrypoint.sh"]
#CMD ["/bin/bash"]