ARG VARIANT="jammy"
FROM ubuntu:${VARIANT}

# [Option] Install zsh
ARG INSTALL_ZSH="true"
ARG INSTALL_OH_MY_ZSH="true"
ARG ADD_NON_FREE_PACKAGES="false"

# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="true"

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

COPY .devcontainer/library-scripts/*.sh .devcontainer/library-scripts/*.env /tmp/library-scripts/
RUN yes | unminimize 2>&1 \
    && bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "${INSTALL_OH_MY_ZSH}" "${ADD_NON_FREE_PACKAGES}"

# Setup default python tools in a venv via pipx to avoid conflicts
ENV PIPX_HOME=/usr/local/py-utils \
    PIPX_BIN_DIR=/usr/local/py-utils/bin
ENV PATH=${PATH}:${PIPX_BIN_DIR}

# Install Python versions 3.8.13, 3.9.12 and 3.10.4
RUN bash /tmp/library-scripts/python-debian.sh "3.8.13" "/usr/local/python-3.8.13" "${PIPX_HOME}" "${USERNAME}" \
     && apt-get clean -y && rm -rf /var/lib/apt/lists/*
RUN bash /tmp/library-scripts/python-debian.sh "3.9.12" "/usr/local/python-3.9.12" "${PIPX_HOME}" "${USERNAME}" \
     && apt-get clean -y && rm -rf /var/lib/apt/lists/*
RUN bash /tmp/library-scripts/python-debian.sh "3.10.4" "/usr/local/python-3.10.4" "${PIPX_HOME}" "${USERNAME}" \
     && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install AWS CLI
COPY .devcontainer/library-scripts/awscli-debian.sh /tmp/library-scripts/
RUN bash /tmp/library-scripts/awscli-debian.sh

# Install the git and p10k theme configurations
ENV HOME="/home/${USERNAME}"
COPY .devcontainer/configs/.zshrc "${HOME}/.zshrc"
COPY .devcontainer/configs/.p10k.zsh "${HOME}/.p10k.zsh"
COPY .devcontainer/configs/.gitconfig "${HOME}/.gitconfig"
COPY .devcontainer/configs/.vimrc "${HOME}/.vimrc"

# Create .vscode-server folder and set USER as owner for caching of extensions
RUN mkdir -p $HOME/.vscode-server/extensions \
    && chown -R $USERNAME $HOME/.vscode-server
