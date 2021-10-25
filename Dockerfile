FROM ubuntu:21.04

ENV DEBIAN_FRONTEND=noninteractive

# Requirements
RUN apt-get -y update && apt-get -y install \
      curl \
      fonts-firacode

# Python
RUN apt-get -y update && apt-get -y install \
      python3 \
      python3-pip \
      python3-dev

RUN pip3 install jupyterlab

# JupyterLab theme
RUN pip3 install JLDracula

# Python packages
RUN pip3 install pycryptodome
RUN pip3 install numpy
RUN pip3 install sympy

# Python code formatters
RUN pip3 install jupyterlab_code_formatter
RUN pip3 install black
RUN pip3 install isort

# Add user and create directory
RUN useradd -m jupyter
RUN mkdir -p /home/jupyter/notebook

# Change the user
USER jupyter

# Copy the configuration file after changing the user
RUN mkdir -p /home/jupyter/.jupyter/lab/user-settings/@jupyterlab/notebook-extension
COPY tracker.jupyterlab-settings /home/jupyter/.jupyter/lab/user-settings/@jupyterlab/notebook-extension/

RUN mkdir -p /home/jupyter/.jupyter/lab/user-settings/@jupyterlab/apputils-extension
COPY themes.jupyterlab-settings /home/jupyter/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/

RUN mkdir -p /home/jupyter/.jupyter/lab/user-settings/@ryantam626/jupyterlab_code_formatter
COPY settings.jupyterlab-settings /home/jupyter/.jupyter/lab/user-settings/@ryantam626/jupyterlab_code_formatter/settings.jupyterlab-settings

EXPOSE 8888
