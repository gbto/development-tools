
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
    nodejs \
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
ENV SHELL /bin/zsh
ENV HOME /home
WORKDIR $HOME

# Install custom terminal
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
ADD configs/.zshrc $HOME
ADD configs/.p10k.zsh $HOME

# Organize programming folder
ENV WORKSPACE_FOLDER $HOME/Programming
RUN mkdir $WORKSPACE_FOLDER
CMD [ "zsh" ]
