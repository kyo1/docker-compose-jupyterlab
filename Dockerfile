FROM python:3.10.11-slim-bullseye

ENV DEBIAN_FRONTEND=noninteractive

RUN pip3 install jupyterlab

# JupyterLab theme
RUN pip3 install JLDracula

# Code formatter plugin
RUN pip3 install jupyterlab_code_formatter

# Python code formatters
RUN pip3 install black
RUN pip3 install isort

# Python packages
RUN pip3 install numpy
RUN pip3 install sympy
RUN pip3 install pycryptodome

# Add user and create directory
RUN useradd -m jupyter
RUN mkdir -p /home/jupyter/notebook

# Change the user
USER jupyter

# Code completion
# RUN pip3 install jupyterlab_tabnine

# Copy the configuration file after changing the user
RUN mkdir -p /home/jupyter/.jupyter/lab/user-settings/@jupyterlab/notebook-extension
COPY settings/tracker.jupyterlab-settings /home/jupyter/.jupyter/lab/user-settings/@jupyterlab/notebook-extension/

RUN mkdir -p /home/jupyter/.jupyter/lab/user-settings/@jupyterlab/apputils-extension
COPY settings/themes.jupyterlab-settings /home/jupyter/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/

RUN mkdir -p /home/jupyter/.jupyter/lab/user-settings/@jupyterlab/shortcuts-extension
COPY settings/shortcuts.jupyterlab-settings /home/jupyter/.jupyter/lab/user-settings/@jupyterlab/shortcuts-extension/

RUN mkdir -p /home/jupyter/.jupyter/lab/user-settings/@ryantam626/jupyterlab_code_formatter
COPY settings/settings.jupyterlab-settings /home/jupyter/.jupyter/lab/user-settings/@ryantam626/jupyterlab_code_formatter/settings.jupyterlab-settings

EXPOSE 8888
