FROM python:3.10.11-slim-bullseye

ENV DEBIAN_FRONTEND=noninteractive

# Add user and create directory
RUN useradd -m john
RUN mkdir -p /home/john/notebooks

# Install requirements
RUN apt-get -y update \
 && apt-get -y install \
      wget \
      curl \
      gpg \
      bzip2 \
 && apt-get -y autoremove \
 && apt-get -y clean \
 && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# Install Node.js
# RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash - \
#  && apt-get -y install nodejs

# Install Micromamba
ENV MAMBA_ROOT_PREFIX=/home/john
RUN curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar jxv bin/micromamba -C /usr/local/bin/micromamba

# Install SageMath
ENV PYDEVD_DISABLE_FILE_VALIDATION=1
RUN micromamba create -y -c conda-forge -n sage sage=9.8 \
 && echo '#!/bin/bash\nmicromamba run -n sage sage "${@}"' > /usr/local/bin/sage \
 && chmod +x /usr/local/bin/sage

# Install Julia
ENV JULIA_VERSION=1.8.5
ENV PATH /opt/julia-${JULIA_VERSION}/bin:${PATH}
RUN wget https://julialang-s3.julialang.org/bin/linux/x64/$(echo ${JULIA_VERSION} | cut -d . -f 1,2)/julia-${JULIA_VERSION}-linux-x86_64.tar.gz \
 && wget https://julialang-s3.julialang.org/bin/linux/x64/$(echo ${JULIA_VERSION} | cut -d . -f 1,2)/julia-${JULIA_VERSION}-linux-x86_64.tar.gz.asc \
 && gpg --keyserver keyserver.ubuntu.com --recv-keys 66E3C7DC03D6E495 \
 && gpg --verify julia-${JULIA_VERSION}-linux-x86_64.tar.gz.asc \
 && tar zxvf julia-${JULIA_VERSION}-linux-x86_64.tar.gz -C /opt \
 && rm julia-${JULIA_VERSION}-linux-x86_64.tar.gz \
 && rm julia-${JULIA_VERSION}-linux-x86_64.tar.gz.asc

# Install JupyterLab and plugins
RUN pip3 install --no-cache-dir \
      jupyterlab \
      jupyterlab_code_formatter \
      JLDracula

# Change the user
USER john

# Install requirements for Python
RUN pip3 install --no-cache-dir \
      ipywidgets \
      black \
      isort

# Python packages
RUN pip3 install --no-cache-dir \
      tqdm \
      pycryptodome \
      numpy \
      sympy \
      scipy \
      polars \
      matplotlib

# Sagemath packages
RUN sage -pip install --no-cache-dir \
      tqdm \
      pycryptodome

# Julia packages
RUN julia -e 'using Pkg; Pkg.add("Primes")'

# Add the kernels
RUN mkdir -p ${HOME}/.local/share/jupyter/kernels \
 && sage -pip install --no-cache-dir jupyterlab \
 && ln -s /home/john/envs/sage/share/jupyter/kernels/sagemath ${HOME}/.local/share/jupyter/kernels/sagemath-9.8 \
 && julia -e 'using Pkg; Pkg.add("IJulia")'

# Copy the configuration files
RUN mkdir -p /home/john/.jupyter/lab/user-settings/@jupyterlab/notebook-extension
COPY --chown=john:john settings/tracker.jupyterlab-settings /home/john/.jupyter/lab/user-settings/@jupyterlab/notebook-extension/

RUN mkdir -p /home/john/.jupyter/lab/user-settings/@jupyterlab/apputils-extension
COPY --chown=john:john settings/themes.jupyterlab-settings /home/john/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/

RUN mkdir -p /home/john/.jupyter/lab/user-settings/@ryantam626/jupyterlab_code_formatter
COPY --chown=john:john settings/settings.jupyterlab-settings /home/john/.jupyter/lab/user-settings/@ryantam626/jupyterlab_code_formatter/settings.jupyterlab-settings

EXPOSE 8888
