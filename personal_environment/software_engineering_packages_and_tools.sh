function install_software_engineering_tools() {
  echo "<<<<<< Software engineering packages and so on"

  echo "<<< Java through SDKMAN"

  curl -s "https://get.sdkman.io" | bash &&
    source $HOME/.sdkman/bin/sdkman-init.sh

  yes Y | sdk install java

  echo "<<< JMeter"

  JMETER_VERSION="5.4"
  JMETER_SHORTER_FILE_NAME="apache-jmeter"
  JMETER_FILE_NAME="${JMETER_SHORTER_FILE_NAME}-${JMETER_VERSION}"
  JMETER_HOME=$(cd $DEV_WORKSPACE_TOOLS && pwd)/$JMETER_FILE_NAME

  curl -O "http://mirror.nbtelecom.com.br/apache//jmeter/binaries/${JMETER_FILE_NAME}.tgz" &&
    tar -xvzf ${JMETER_FILE_NAME}.tgz &&
    mv $JMETER_FILE_NAME $DEV_WORKSPACE_TOOLS &&
    rm -rf "${JMETER_FILE_NAME}"*

  ln -sv $JMETER_HOME $DEV_WORKSPACE_TOOLS/$JMETER_SHORTER_FILE_NAME

  echo "<<< Python through pipenv"

  PYENV_VERSION="3.9.4"
  curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
  export PATH=$HOME/.pyenv/bin:$PATH
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
  pyenv install $PYENV_VERSION
  pyenv versions
  pyenv global $PYENV_VERSION
  SOURCE_STR="\\nexport PATH=\"${HOME}/.pyenv/bin:\$PATH\"\\neval \"\$(pyenv init -)\"\\neval \"\$(pyenv virtualenv-init -)\"\\n"
  command printf "${SOURCE_STR}" >>$HOME/.bashrc

  echo "<<<<<< Node through nvm"

  NVM_VERSION="v0.38.0"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash
  NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm install --lts

  echo "<<< GO through goenv - TODO"

  # https://github.com/syndbg/goenv

  echo "<<< Ruby through rbenv"

  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  cd ~/.rbenv && src/configure && make -C src
  ~/.rbenv/bin/rbenv init
  mkdir -p "$(rbenv root)"/plugins
  git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build

  echo "<<< Dotnet"

  # https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu
  # https://docs.microsoft.com/en-us/dotnet/core/install/linux
  # https://dev.to/carlos487/installing-dotnet-core-in-ubuntu-20-04-6jh
  # https://docs.microsoft.com/en-us/dotnet/core/install/linux-snap

  sudo snap install dotnet-sdk --classic --channel=5.0
  sudo snap alias dotnet-sdk.dotnet dotnet

  echo "<<< Docker"

  DOCKER_COMPOSE_VERSION="1.29.2"

  VENDOR="$(lsb_release -i | awk '{print $3}' | awk '{print tolower($0)}')"
  CODENAME="$(lsb_release -cs)"

  curl -fsSL https://download.docker.com/linux/${VENDOR}/gpg | sudo apt-key add -

  sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/${VENDOR} ${CODENAME} stable"
  sudo apt update && sudo apt-cache policy docker-ce &&
    sudo apt install -y docker-ce &&
    sudo usermod -aG docker $USER &&
    echo "<<< Docker Compose" &&
    sudo curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose &&
    sudo chmod +x /usr/local/bin/docker-compose

  echo "<<< Git"

  GITHUB_KEYFILE="github"
  GITHUB_KEYFILE_FULL_PATH=$DEV_WORKSPACE_KEYS/$GITHUB_KEYFILE
  SSH_FOLDER=~/.ssh
  SSH_KEYCHAIN_CONFIG='Host github.com
    IgnoreUnknown AddKeysToAgent,UseKeychain
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile '"$GITHUB_KEYFILE_FULL_PATH"''

  ssh-keygen -t rsa -b 4096 -C "willian.lima.antunes@gmail.com" -f $GITHUB_KEYFILE_FULL_PATH
  echo "<< Starting the ssh-agent..."
  eval "$(ssh-agent -s)"

  echo "<< Adding the PRIVATE ssh-key to the ssh-agent"
  ssh-add -K $GITHUB_KEYFILE_FULL_PATH

  echo "<< Appending config to ssh-config file... Do not forget to copy your public key and fill it on GitHub page!"
  echo "$SSH_KEYCHAIN_CONFIG" >>$SSH_FOLDER/config

  echo "<<< K8S"

  KUBECTL_STABLE_VERSION=`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`
  cd $DEV_WORKSPACE_TOOLS && \
  curl -LO https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_STABLE_VERSION/bin/linux/amd64/kubectl && \
  chmod +x ./kubectl

  echo "<<< AWS"

  yes | pip install awscli

  cd $DEV_WORKSPACE_TOOLS && \
  curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/aws-iam-authenticator && \
  chmod +x ./aws-iam-authenticator

  echo "<<< GCP"

  # Add the Cloud SDK distribution URI as a package source
  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

  # Import the Google Cloud Platform public key
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

  # Update the package list and install the Cloud SDK
  sudo apt-get update && sudo apt-get install -y -q google-cloud-sdk

  echo "<<< Azure"

  curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

  echo "<<< Terraform"

  TERRAFORM_VERSION="1.0.1"
  git clone https://github.com/tfutils/tfenv.git $HOME/.tfenv
  cd $HOME/.tfenv/bin && export PATH=$PATH:$HOME/.tfenv/bin && tfenv install $TERRAFORM_VERSION && tfenv use $TERRAFORM_VERSION

  echo "<<< NGROK"

  cd $DEV_WORKSPACE_TOOLS && \
  curl -o ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip && \
  unzip ngrok.zip && rm ngrok.zip && chmod +x ngrok

  echo "<<< Bitcoin"

  # https://bitcoin.org/en/download
  # https://github.com/bitcoin/bitcoin/releases

  sudo snap install bitcoin-core

  echo "<<< ZSH"

  sudo apt install -y -q zsh && chsh -s $(which zsh)
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}
