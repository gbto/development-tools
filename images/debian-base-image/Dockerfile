FROM debian:stretch-20220125-slim
LABEL maintainer="gibboneto@gmail.com"

ARG USER_NAME="debian"
ARG USER_PASSWORD="password"

ENV USER_NAME $USER_NAME
ENV USER_PASSWORD $USER_PASSWORD
ENV CONTAINER_IMAGE_VER=v1.0.0

RUN echo $USER_NAME
RUN echo $USER_PASSWORD
RUN echo $CONTAINER_IMAGE_VER

# Configure apt
ENV DEBIAN_FRONTEND=noninteractive

# Install webserver content retrievers
RUN apt-get update && \
    apt-get install -y sudo \
    build-essential \
    curl \
    git-core \
    gnupg \
    make \
    nodejs \
    wget \
    zsh

# Add user to run the
RUN useradd -ms /bin/zsh $USER_NAME
USER $USER_NAME
WORKDIR /home/$USER_NAME

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
ENV SHELL /bin/zsh
ENV HOME /home/$USER_NAME
WORKDIR $HOME

# The user we're applying this to
USER $USER_NAME

# Install custom terminal
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
ADD configs/.zshrc $HOME
ADD configs/.p10k.zsh $HOME

# Organize programming folder
ENV WORKSPACE_FOLDER $HOME/Programming
RUN mkdir $WORKSPACE_FOLDER
CMD [ "zsh" ]
