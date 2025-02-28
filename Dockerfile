# Base image
FROM nvcr.io/nvidia/pytorch:25.02-py3

RUN apt-get update --allow-insecure-repositories && \
    apt-get install -y --allow-unauthenticated git curl wget build-essential unzip && \
    rm -rf /var/lib/apt/lists/*

# Copy application code to container
COPY . /app
WORKDIR /app

RUN pip install -e . --verbose

CMD ["/bin/bash"]

