# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.217.4/containers/debian/.devcontainer/base.Dockerfile

FROM debian:stretch-slim

LABEL maintainer="gibboneto@gmail.com"

# Configure apt
ENV DEBIAN_FRONTEND=noninteractive

# Install webserver content retrievers
RUN apt-get update && \
    apt-get install -y sudo \
    build-essential \
    wget \
    curl \
    zsh \
    git \
    gnupg \
    libbz2-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    llvm \
    make \
    tk-dev \
    xz-utils \
    zlib1g-dev

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog

ENV USER_NAME gibboneto
ENV USER_PASSWORD blackbriar

# Add a user (--disabled-password: the user won't be able to use the account until the password is set)
RUN adduser --quiet --disabled-password --shell /bin/zsh --home /home/$USER_NAME --gecos "User" $USER_NAME
# Update the password
RUN echo "${USER_NAME}:${USER_PASSWORD}" | chpasswd && usermod -aG sudo $USER_NAME
RUN echo $USER_NAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USER_NAME && chmod 0440 /etc/sudoers.d/$USER_NAME

ENV SHELL /bin/zsh
ENV HOME /home/$USER_NAME
WORKDIR $HOME
# Install custom terminal
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k

# Install python and pyenv
RUN apt-get install -y git
RUN git clone --depth=1 https://github.com/pyenv/pyenv.git .pyenv
ENV PYENV_ROOT="${HOME}/.pyenv"
ENV PATH="${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:${PATH}"

ENV PYTHON_VERSION=3.8.6
RUN pyenv install ${PYTHON_VERSION}
RUN pyenv global ${PYTHON_VERSION}

# Python defaults to ASCII encoding. Switch to UTF-8
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# Add zsh configuration
ADD /configs/.zshrc $HOME
ADD /configs/.p10k.zsh $HOME
RUN exec zsh

# Add
RUN mkdir $HOME/Programming/
ADD /dependencies/requirements.txt $HOME/Programming/
