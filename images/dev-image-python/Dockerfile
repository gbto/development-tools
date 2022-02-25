FROM ghcr.io/gbto/base-image-debian:1.0.0
LABEL maintainer="gibboneto@gmail.com"
LABEL org.opencontainers.image.source="https://github.com/gbto/tools"
LABEL version="1.0.0"

USER root

# Install required utils
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    llvm \
    libncurses5-dev xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev

# Re-use user created in parent image
ENV USER_NAME="gibboneto"
ENV HOME=/home/$USER_NAME
USER $USER_NAME
WORKDIR $HOME

# Install python and pyenv
ARG PYTHON_VERSION=3.8.12
RUN git clone --depth=1 https://github.com/pyenv/pyenv.git .pyenv
ENV PYENV_ROOT="$HOME/.pyenv"
ENV PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH"
RUN pyenv install $PYTHON_VERSION
RUN pyenv global $PYTHON_VERSION

# Python defaults to ASCII encoding. Switch to UTF-8
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8`

# Add programming directory
RUN mkdir $HOME/Programming/
ADD requirements.txt $HOME/Programming/
RUN pip install -r $HOME/Programming/requirements.txt
