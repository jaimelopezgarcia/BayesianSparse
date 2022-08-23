ARG BASE_IMAGE="ubuntu"
FROM $BASE_IMAGE

USER root



WORKDIR /home/project


ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Madrid
ENV PIP_VERSION="21.1.1"
ENV NODEJS_VERSION=16
ENV JUPYTER_TOKEN=token
ENV PORT_JUPYTER=8888
ENV PORT_TENSORBOARD=8887
ENV CONDA_DIR=/conda/opt
ENV PATH=$CONDA_DIR/bin:$PATH


RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    apt-get update && apt-get install --no-install-recommends -y \
    curl screen vim git locate && \
    apt-get install -y software-properties-common && \

    rm -rf /var/lib/apt/lists/*



RUN apt-get update &&\
    curl -o ./conda.sh https://repo.anaconda.com/miniconda/Miniconda3-py39_4.12.0-Linux-x86_64.sh &&\
    bash ./conda.sh -b -p $CONDA_DIR && conda init bash &&\
    rm -rf /var/lib/apt/lists/*

RUN yes | (conda create -c conda-forge -n pymc_env "pymc>=4") 

RUN conda run -n pymc_env pip install jupyterlab &&\
    echo -e '#!/bin/bash\njupyter lab --allow-root --port 8888 --ip 0.0.0.0'>/usr/bin/run_jupyter &&\
    chmod +x /usr/bin/run_jupyter &&\
    rm -rf /var/lib/apt/lists/*







