#!/usr/bin/env bash

# https://www.willianantunes.com/blog/2021/05/production-ready-shell-startup-scripts-the-set-builtin/
set -eux -o pipefail

source "${BASH_SOURCE%/*}/../utils/helpers.sh"
source "${BASH_SOURCE%/*}/settings.sh"

"${APT_GET[@]}" update

# Important comment here!
# For each installation, I might have added extra configuration.
# Check out ".profile", ".executed_in_every_login" and ".executed_in_every_interactive_shell" files

echo "<<<<<< Install pyenv (Python Version Management)"
# https://github.com/pyenv/pyenv/wiki#suggested-build-environment
"${APT_GET_INSTALL[@]}" make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
# https://github.com/pyenv/pyenv#basic-github-checkout
[ ! -d "$HOME/.pyenv" ] && git clone https://github.com/pyenv/pyenv.git "$HOME/.pyenv"

echo "<<<<<< Install tfenv (Terraform version manager)"
[ ! -d "$HOME/.tfenv" ] && git clone https://github.com/tfutils/tfenv.git "$HOME/.tfenv"

echo "<<<<<< Install goenv (Go Version Management)"
[ ! -d "$HOME/.goenv" ] && git clone https://github.com/syndbg/goenv.git "$HOME/.goenv"

echo "<<<<<< Install nvm (Node Version Manager)"
# https://github.com/nvm-sh/nvm#git-install
export NVM_DIR="$HOME/.nvm" && [ ! -d "$NVM_DIR" ] && (
  git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
  cd "$NVM_DIR"
  git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
)

echo "<<<<<< Install rbenv (Ruby Version Manager)"
# https://github.com/rbenv/rbenv#basic-github-checkout
"${APT_GET_INSTALL[@]}" autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev \
zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev
[ ! -d "$HOME/.rbenv" ] && git clone https://github.com/rbenv/rbenv.git "$HOME/.rbenv" && \
mkdir "$HOME/.rbenv/plugins" && git clone https://github.com/rbenv/ruby-build.git "$HOME/.rbenv/plugins/ruby-build"

echo "<<<<<< Install sdkman (The Software Development Kit Manager)"
# https://sdkman.io/install
# To install the LTS version: yes Y | sdk install java
curl -s "https://get.sdkman.io?rcupdate=false" | bash

echo "<<<<<< Generate SSH keys"
GITHUB_KEYFILE="github"
GITHUB_KEYFILE_FULL_PATH=$DEV_WORKSPACE_KEYS/$GITHUB_KEYFILE
SSH_FOLDER=~/.ssh
SSH_KEYCHAIN_CONFIG='Host github.com
    AddKeysToAgent yes
    IdentityFile '"$GITHUB_KEYFILE_FULL_PATH"''
ssh-keygen -t rsa -b 4096 -C "$MY_PROVIDED_EMAIL" -f $GITHUB_KEYFILE_FULL_PATH -P "$MY_PROVIDED_PASSPHRASE"
echo "$SSH_KEYCHAIN_CONFIG" >> $SSH_FOLDER/config

echo "<<<<<< JMeter"
JMETER_VERSION="5.4"
JMETER_SHORTER_FILE_NAME=apache-jmeter
JMETER_FILE_NAME="$JMETER_SHORTER_FILE_NAME-$JMETER_VERSION"
JMETER_HOME="$DEV_WORKSPACE_TOOLS/$JMETER_FILE_NAME"

"${CURL[@]}" "https://ftp.unicamp.br/pub/apache/jmeter/binaries/${JMETER_FILE_NAME}.tgz" | tar xz
mv $JMETER_FILE_NAME $DEV_WORKSPACE_TOOLS
rm -rf "${JMETER_FILE_NAME}*"
ln --symbolic --verbose $JMETER_HOME $DEV_WORKSPACE_TOOLS/$JMETER_SHORTER_FILE_NAME

echo "<<<<<< Install Dotnet"
# https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu
# https://docs.microsoft.com/en-us/dotnet/core/install/linux-snap
sudo snap install dotnet-sdk --classic --channel=5.0
sudo snap alias dotnet-sdk.dotnet dotnet

echo "<<<<<< Install Bitcoin"
# https://bitcoin.org/en/download
# https://github.com/bitcoin/bitcoin/releases
sudo snap install bitcoin-core

echo "<<<<<< Install zsh and ohmyzsh"
# https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH
# https://github.com/ohmyzsh/ohmyzsh#basic-installation
"${APT_GET_INSTALL[@]}" zsh
sudo chsh -s $(which zsh) $(whoami)
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
