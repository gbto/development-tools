FROM ubuntu:22.04
LABEL maintainer="gibboneto@gmail.com"
LABEL org.opencontainers.image.source https://github.com/gbto/tools

ARG USER_NAME="ubuntu"
ARG USER_PASSWORD="password"
ARG PYTHON_VERSION=3.8.6

ENV USER_NAME $USER_NAME
ENV USER_PASSWORD $USER_PASSWORD
ENV CONTAINER_IMAGE_VER=v1.0.0

RUN echo $USER_NAME
RUN echo $USER_PASSWORD
RUN echo $CONTAINER_IMAGE_VER

# Configure apt
ENV DEBIAN_FRONTEND=noninteractive

# Install general tools
RUN apt-get update && \
    apt-get install -y sudo \
    build-essential \
    curl \
    fonts-powerline \
    git-core \
    gnupg \
    make \
    nodejs \
    wget \
    zsh

# Add and set user
RUN useradd -r -m -d /home/$USER_NAME -s /bin/zsh -g root -G sudo -u 1001 $USER_NAME
USER $USER_NAME
WORKDIR /home/$USER_NAME
USER $USER_NAME

# Install omz and the power10k theme
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
RUN curl -o .zshrc -LJO https://raw.githubusercontent.com/gbto/tools/main/configs/terminal/.zshrc
RUN curl -o .p10k.zsh -LJO https://raw.githubusercontent.com/gbto/tools/main/configs/power10k/linux.p10k.zsh
# Install relevant plugings
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog

# TODO: lower the permissions of the user by changing its usergroup
CMD [ "zsh" ]
