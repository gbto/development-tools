# Image currently locked to debian buster.
FROM arm64v8/debian

# Copy settings file so Docker extension is installed inside the container
COPY settings.vscode.json /root/.vscode-remote/data/Machine/settings.json

# Configure apt
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get -y install --no-install-recommends apt-utils 2>&1

# Install Update Apt and install apps
RUN  apt-get update && \
    apt-get install -y zsh \
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
    sudo

# Install and set-up oh-my-zsh
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen

# Install docker
RUN curl -fsSL https://get.docker.com | sh

# # Set-up and install terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - && \
    sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    wget https://releases.hashicorp.com/terraform/1.1.9/terraform_1.1.9_linux_arm64.zip && \
    unzip terraform_1.1.9_linux_arm64.zip && \
    mv terraform /usr/local/bin/

# Install pyenv for python version
RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv

# # Install poetry for python environments
# RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -

# Configure oh-my-zsh
COPY configs/.zshrc /root/.zshrc
COPY configs/.p10k.zsh /root/.p10k.zsh

# terminal colors with xterm
ENV TERM xterm

# Clean up
RUN apt-get autoremove -y && apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*
ENV DEBIAN_FRONTEND=dialog


# Create working directory
RUN mkdir /root/Programming
WORKDIR /root/Programming

# Run zsh
CMD ["zsh"]

