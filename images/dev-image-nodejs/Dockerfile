FROM ghcr.io/gbto/base-image-debian:1.0.0
LABEL maintainer="gibboneto@gmail.com"
LABEL org.opencontainers.image.source https://github.com/gbto/tools
ENV CONTAINER_IMAGE_VER=v1.0.0

# Re-use user created in parent image
ARG USER_NAME="gibboneto"
USER $USER_NAME
ENV HOME=/home/$USER_NAME
WORKDIR $HOME

# Install NVM
ENV NVM_DIR="$HOME/.nvm"
ENV NODE_VERSION="12.6.0"

# Set user as root for the below installations
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# Add commands to zsh config file to load nvm at run-time
RUN echo 'export NVM_DIR="$HOME/.nvm"' >> $HOME/.zshrc
RUN echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> $HOME/.zshrc  # This loads nvm
RUN echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> $HOME/.zshrc # This load auto completion

# Add node to path in order to access npm at built time
ENV PATH="$HOME/.nvm/versions/node/v$NODE_VERSION/bin/:$PATH"

# Install packages
RUN npm install --global yarn

CMD ["zsh"]
