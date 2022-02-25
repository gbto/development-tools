FROM debian:stretch-20220125-slim
LABEL maintainer="Gbto, <gibboneto@gmail.com>"
LABEL org.opencontainers.image.source="https://github.com/gbto/tools"
LABEL version="1.0.0"

# Configure apt
ENV DEBIAN_FRONTEND=noninteractive
USER root

# Install webserver content retrievers
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

# Install omz and the power10k theme
RUN sudo sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
RUN curl -o .zshrc -LJO https://raw.githubusercontent.com/gbto/tools/main/configs/terminal/.zshrc
RUN curl -o .p10k.zsh -LJO https://raw.githubusercontent.com/gbto/tools/main/configs/power10k/linux.p10k.zsh

# Install relevant plugins
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Create a user with privileges
ENV USER_NAME="gibboneto"
RUN adduser --disabled-password --gecos '' ${USER_NAME}
RUN adduser ${USER_NAME} sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >>  /etc/sudoers

# Change user
USER ${USER_NAME}
WORKDIR /home/$USER_NAME

# Install omz and the power10k theme for non-root user
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
RUN curl -o .zshrc -LJO https://raw.githubusercontent.com/gbto/tools/main/configs/terminal/.zshrc
RUN curl -o .p10k.zsh -LJO https://raw.githubusercontent.com/gbto/tools/main/configs/power10k/linux.p10k.zsh

# Install plugings
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog

CMD [ "zsh" ]
