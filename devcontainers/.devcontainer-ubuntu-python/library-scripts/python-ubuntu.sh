#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------
#
# Docs: https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/docs/python.md
# Maintainer: The VS Code and Codespaces Teams
#
# Syntax: ./python-debian.sh [Python Version] [Python intall path] [PIPX_HOME] [non-root user] [Update rc files flag] [install tools flag] [Use Oryx if available flag] [Optimize when building from source flag]

# PYTHON_VERSION=${1:-"latest"} # 'system' checks the base image first, else installs 'latest'
# PYTHON_INSTALL_PATH=${2:-"/usr/local/python"}
# export PIPX_HOME=${3:-"/usr/local/py-utils"}
# USERNAME=${4:-"automatic"}
# UPDATE_RC=${5:-"true"}
# INSTALL_PYTHON_TOOLS=${6:-"true"}
# USE_ORYX_IF_AVAILABLE=${7:-"true"}
# OPTIMIZE_BUILD_FROM_SOURCE=${8-"false"}

DEFAULT_UTILS=("pylint" "flake8" "autopep8" "black" "yapf" "mypy" "pydocstyle" "pycodestyle" "bandit" "pipenv" "virtualenv")
PYTHON_SOURCE_GPG_KEYS="64E628F8D684696D B26995E310250568 2D347EA6AA65421D FB9921286F5E1540 3A5CA953F73C700D 04C367C218ADD4FF 0EDDC5F26A45C816 6AF053F07D9DC8D2 C9BE28DEE6DF025C 126EB563A74B06BF D9866941EA5BBD71 ED9D77D5"
GPG_KEY_SERVERS="keyserver hkp://keyserver.ubuntu.com:80
keyserver hkps://keys.openpgp.org
keyserver hkp://keyserver.pgp.com"

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Ensure that login shells get the correct path if the user updated the PATH using ENV.
rm -f /etc/profile.d/00-restore-env.sh
echo "export PATH=${PATH//$(sh -lc 'echo $PATH')/\$PATH}" > /etc/profile.d/00-restore-env.sh
chmod +x /etc/profile.d/00-restore-env.sh

# Determine the appropriate non-root user
if [ "${USERNAME}" = "auto" ] || [ "${USERNAME}" = "automatic" ]; then
    USERNAME=""
    POSSIBLE_USERS=("vscode" "node" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
    for CURRENT_USER in ${POSSIBLE_USERS[@]}; do
        if id -u ${CURRENT_USER} > /dev/null 2>&1; then
            USERNAME=${CURRENT_USER}
            break
        fi
    done
    if [ "${USERNAME}" = "" ]; then
        USERNAME=root
    fi
elif [ "${USERNAME}" = "none" ] || ! id -u ${USERNAME} > /dev/null 2>&1; then
    USERNAME=root
fi

# Function to run apt-get if needed
apt_get_update_if_needed()
{
    if [ ! -d "/var/lib/apt/lists" ] || [ "$(ls /var/lib/apt/lists/ | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update
    else
        echo "Skipping apt-get update."
    fi
}

# Checks if packages are installed and installs them if not
check_packages() {
    if ! dpkg -s "$@" > /dev/null 2>&1; then
        apt_get_update_if_needed
        apt-get -y install --no-install-recommends "$@"
    fi
}


# Ensure apt is in non-interactive to avoid prompts
export DEBIAN_FRONTEND=noninteractive

# General requirements
check_packages curl ca-certificates gnupg2 tar make gcc libssl-dev zlib1g-dev libncurses5-dev \
            libbz2-dev libreadline-dev libxml2-dev xz-utils libgdbm-dev tk-dev dirmngr \
            libxmlsec1-dev libsqlite3-dev libffi-dev liblzma-dev lzma uuid-dev

# Install Pyenv and Pyenv-Virtualenv
if [ ! -r ~/.pyenv/ ]
then
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
    echo '
# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)" # Enable auto-activation of virtualenvs
fi' >> ~/.zshrc
    source ~/.zshrc
    exec "$SHELL"
fi

# Install Environments


# Install tools
echo "Installing Python tools..."
export PYTHONUSERBASE=/tmp/pip-tmp
export PIP_CACHE_DIR=/tmp/pip-tmp/cache
pipx_path=""
if ! type pipx > /dev/null 2>&1; then
    pip3 install --disable-pip-version-check --no-cache-dir --user pipx 2>&1
    /tmp/pip-tmp/bin/pipx install --pip-args=--no-cache-dir pipx
    pipx_path="/tmp/pip-tmp/bin/"
fi
for util in ${DEFAULT_UTILS[@]}; do
    if ! type ${util} > /dev/null 2>&1; then
        ${pipx_path}pipx install --system-site-packages --pip-args '--no-cache-dir --force-reinstall' ${util}
    else
        echo "${util} already installed. Skipping."
    fi
done
rm -rf /tmp/pip-tmp

updaterc "$(cat << EOF
export PIPX_HOME="${PIPX_HOME}"
export PIPX_BIN_DIR="${PIPX_BIN_DIR}"
if [[ "\${PATH}" != *"\${PIPX_BIN_DIR}"* ]]; then export PATH="\${PATH}:\${PIPX_BIN_DIR}"; fi
EOF
)"

