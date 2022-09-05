# Image currently locked to debian buster.
FROM arm64v8/debian:stable-slim

# Copy settings file so Docker extension is installed inside the container
COPY settings.vscode.json /root/.vscode-remote/data/Machine/settings.json

# Configure apt
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_VERSION=1.1.13

# Install Linux packages
RUN  apt-get update && \
    apt-get install --no-install-recommends -y apt-utils \
    zsh \
    apt-transport-https \
    awscli \
    ca-certificates \
    curl \
    fonts-powerline \
    gnupg \
    gnupg-agent \
    git \
    locales \
    procps \
    python3-pip \
    software-properties-common \
    lsb-release \
    unzip \
    wget \
    vim \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Use Python 3 for `python`, `pip`
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1 \
    && update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1

# Install and set-up oh-my-zsh
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN wget --progress=dot:giga "https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh" -O - | zsh || true && \
    git clone "https://github.com/zsh-users/zsh-syntax-highlighting" "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" && \
    git clone "https://github.com/zsh-users/zsh-autosuggestions" "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" && \
    git clone --depth=1 "https://github.com/romkatv/powerlevel10k.git" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen

# Configure oh-my-zsh
COPY configs/.zshrc /root/.zshrc
COPY configs/.p10k.zsh /root/.p10k.zsh

# Install and set-up Terraform
RUN curl -fsSL "https://apt.releases.hashicorp.com/gpg" | apt-key add - && \
    apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    wget --progress=dot:giga "https://releases.hashicorp.com/terraform/1.1.9/terraform_1.1.9_linux_arm64.zip" && \
    unzip "terraform_1.1.9_linux_arm64.zip" && \
    mv terraform "/usr/local/bin/"

# Install Rust
RUN curl "https://sh.rustup.rs" -sSf | bash -s -- -y

# Install pyenv
RUN git clone "https://github.com/pyenv/pyenv.git" ~/.pyenv

# Project initialization
RUN curl -sSL "https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py" | python3

# Install pants
RUN curl -L -O "https://static.pantsbuild.org/setup/pants" && chmod +x ./pants

# Install python formatters
RUN pip3 install --no-cache-dir flake8 black

# Install Docker CE CLI
RUN curl -fsSL "https://get.docker.com" | sh

# Install Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/download/v2.10.2/docker-compose-$(uname -s)-$(uname -m)" -o "/usr/local/bin/docker-compose"
RUN chmod +x /usr/local/bin/docker-compose

# terminal colors with xterm
ENV TERM xterm

# Clean up
RUN apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*
ENV DEBIAN_FRONTEND=dialog

# Create working directory
RUN mkdir /root/Programming
WORKDIR /root/Programming

# Run zsh
CMD ["zsh"]

