FROM ubuntu:20.04

# Requirements
RUN apt -y update && apt -y install \
      curl

# Python
RUN apt -y update && apt -y install \
      python3 \
      python3-pip \
      python3-dev

RUN pip3 install jupyterlab

# Ruby
RUN apt -y update && apt -y install \
      libtool \
      libffi-dev \
      ruby \
      ruby-dev \
      make \
      libzmq3-dev \
      libczmq-dev

RUN gem install ffi-rzmq
RUN gem install iruby --pre

# Julia
RUN apt -y update && apt -y install julia

# Node.js for JupyterLab extensions
# https://github.com/nodesource/distributions
RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt -y install nodejs

# JupyterLab extensions
RUN jupyter labextension install @oriolmirosa/jupyterlab_materialdarker

# Add user and create directory
RUN useradd -m jupyter
RUN mkdir -p /home/jupyter/notebook

# Change the user
USER jupyter

# Add the kernel after changing the user
RUN iruby register --force # ruby kernel
RUN julia -e 'using Pkg; Pkg.add("IJulia")' # julia kernel

# Copy the configuration file after changing the user
RUN mkdir -p /home/jupyter/.jupyter/lab/user-settings/@jupyterlab/notebook-extension
COPY tracker.jupyterlab-settings /home/jupyter/.jupyter/lab/user-settings/@jupyterlab/notebook-extension/

RUN mkdir -p /home/jupyter/.jupyter/lab/user-settings/@jupyterlab/apputils-extension
COPY themes.jupyterlab-settings /home/jupyter/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/

EXPOSE 8888
ENTRYPOINT ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser", "--port=8888", "--notebook-dir=/home/jupyter/notebook"]
