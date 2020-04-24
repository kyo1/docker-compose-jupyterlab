FROM ubuntu:20.04

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

# Add user and create directory
RUN useradd -m jupyter
RUN mkdir -p /home/jupyter/notebook

# Add the kernel when the user changes
USER jupyter
RUN iruby register --force # ruby kernel

EXPOSE 8888
ENTRYPOINT ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser", "--port=8888", "--notebook-dir=/home/jupyter/notebook"]
