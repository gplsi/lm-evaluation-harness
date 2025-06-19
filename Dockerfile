
#FROM nvcr.io/nvidia/pytorch:24.02-py3
FROM nvcr.io/nvidia/pytorch:25.01-py3

# Argumentos para UID y GID
ARG USER_ID
ARG GROUP_ID

RUN groupadd -g $GROUP_ID usergroup && \
    useradd -m -u $USER_ID -g usergroup user

COPY . /app

RUN mkdir -p /app /app/reports /app/models /outputLogs

RUN chgrp -R usergroup /app /app/reports /app/models /outputLogs && \
chmod -R 770 /app /app/reports /app/models /outputLogs && \
chmod g+s /app /app/reports /app/models /outputLogs


WORKDIR /app
# INSTALL PACKAGES
RUN pip install -e . && \
pip uninstall pydantic -y && \
pip install --no-cache-dir pydantic wandb sentencepiece openpyxl && \
apt-get install --reinstall -y ca-certificates

COPY entrypoint.sh /app/launch_scripts/entrypoint.sh
RUN chmod +x -R /app/launch_scripts

USER user
WORKDIR /app/launch_scripts
CMD ["/bin/bash", "entrypoint.sh"]
#CMD ["/bin/bash"]