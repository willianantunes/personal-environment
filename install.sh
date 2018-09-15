#!/bin/bash 
#######################################################
# Description	 : My honest install script to 
#                  prepare my development environment
# Author         : Willian Antunes
# Know more at   : https://github.com/alrra/dotfiles
#                  https://dotfiles.github.io/
#                  https://github.com/webpro/awesome-dotfiles
#                  https://github.com/donnemartin/dev-setup
#                  https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789
#                  https://github.com/mathiasbynens/dotfiles
#                  http://aurelio.net/shell/canivete/
#                  https://github.com/fredcamps/dev-env
#######################################################

ask_for_sudo() { # https://github.com/alrra/dotfiles/blob/7311ef50b65495e89c7dd98fa927e5dfa5ee442b/src/os/utils.sh#L20

    # Ask for the administrator password upfront.

    sudo -v &> /dev/null

    # Update existing `sudo` time stamp
    # until this script has finished.
    #
    # https://gist.github.com/cowboy/3118588

    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done &> /dev/null &

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

ask_for_sudo

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Base stuff
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
VENDOR="$(lsb_release -i | awk '{print $3}' | awk '{print tolower($0)}')"
CODENAME="$(lsb_release -cs)"

echo "<<<<<< Creating development workspace"

DEV_WORKSPACE_SERVERS=~/Development/servers
DEV_WORKSPACE_TOOLS=~/Development/tools
DEV_WORKSPACE_LABS=~/Development/labs
DEV_WORKSPACE_GIT_PERSONAL=~/Development/git-personal
DEV_WORKSPACE_GIT_WORK=~/Development/git-work
DEV_WORKSPACE_TMP=~/Development/tmp

mkdir -p $DEV_WORKSPACE_SERVERS $DEV_WORKSPACE_TOOLS \
    $DEV_WORKSPACE_LABS $DEV_WORKSPACE_GIT_PERSONAL \
    $DEV_WORKSPACE_GIT_WORK $DEV_WORKSPACE_TMP

echo "<<<<<< Including PPA in order to install non-standard packages"

sudo add-apt-repository -y ppa:wireshark-dev/stable

echo "<<<<<< Refreshing repository index"

sudo apt-get update

echo "<<<<<< Utility and must-have packages"

sudo apt install -y -q vim \
    tree \
    gnome-disk-utility \
    wireshark \
    curl \
    nmap \
    git \
    gimp \
    inkscape \
    gdebi-core \
    build-essential libssl-dev \
    apt-transport-https ca-certificates curl software-properties-common
    
systemManufacturer=`dmidecode -s system-manufacturer`

if [[ $systemManufacturer=*"VMware"* ]] || [[ $systemManufacturer=*"VirtualBox"* ]]; then
    echo "<<< It's a VM!"
    sudo apt install open-vm-tools-desktop
fi

echo "<<< Chrome"

curl -OL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&
    sudo gdebi --n google-chrome-stable_current_amd64.deb

echo "<<< Tsuru client"

TSURU_VERSION="1.5.1"
TSURU_SHORTER_FILE_NAME="tsuru"
TSURU_FILE_NAME="${TSURU_SHORTER_FILE_NAME}_${TSURU_VERSION}_linux_amd64"
TSURU_HOME=`cd $DEV_WORKSPACE_TOOLS && pwd`/$TSURU_FILE_NAME

curl -OL "https://github.com/tsuru/tsuru-client/releases/download/${TSURU_VERSION}/${TSURU_FILE_NAME}.tar.gz" && 
    mkdir $TSURU_FILE_NAME &&
    tar -xvzf ${TSURU_FILE_NAME}.tar.gz -C $TSURU_FILE_NAME &&
    mv $TSURU_FILE_NAME $DEV_WORKSPACE_TOOLS &&
    rm -rf "${TSURU_FILE_NAME}"*

ln -sv $TSURU_HOME $DEV_WORKSPACE_TOOLS/$TSURU_SHORTER_FILE_NAME

echo "<<<<<< Java and tools depending on it"

curl -s "https://get.sdkman.io" | bash &&
    source "/home/wantunes/.sdkman/bin/sdkman-init.sh"

yes Y | sdk install java 8.0.181-oracle &&
    sdk install java 10.0.2-open &&
    sdk install maven 3.5.4 &&
    sdk install gradle 4.10.1

echo "<<< JMeter"

JMETER_VERSION="4.0"
JMETER_SHORTER_FILE_NAME="apache-jmeter"
JMETER_FILE_NAME="${JMETER_SHORTER_FILE_NAME}-${JMETER_VERSION}"
JMETER_HOME=`cd $DEV_WORKSPACE_TOOLS && pwd`/$JMETER_FILE_NAME

curl -O "http://mirror.nbtelecom.com.br/apache//jmeter/binaries/${JMETER_FILE_NAME}.tgz" && 
    tar -xvzf ${JMETER_FILE_NAME}.tgz &&
    mv $JMETER_FILE_NAME $DEV_WORKSPACE_TOOLS &&
    rm -rf "${JMETER_FILE_NAME}"*

# https://askubuntu.com/a/723503
sudo sed -i "s/^assistive_technologies=/#&/" /etc/java-11-openjdk/accessibility.properties
sudo sed -i "s/^assistive_technologies=/#&/" /etc/java-8-openjdk/accessibility.properties

ln -sv $JMETER_HOME $DEV_WORKSPACE_TOOLS/$JMETER_SHORTER_FILE_NAME

echo "<<<<<< Node Version Manager"

NVM_VERSION="v0.33.11"

curl -o- https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh | bash

echo "<<<<<< Docker"

DOCKER_COMPOSE_VERSION="1.22.0"

curl -fsSL https://download.docker.com/linux/${VENDOR}/gpg | sudo apt-key add -
sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/${VENDOR} ${CODENAME} stable"
sudo apt update && sudo apt-cache policy docker-ce &&
    sudo apt install -y docker-ce &&
    sudo usermod -aG docker $USER &&
    echo "<<< Docker Compose" &&
    sudo curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose &&
    sudo chmod +x /usr/local/bin/docker-compose

echo "<<<<<< Dotfiles"

ln -sfv "$DOTFILES_DIR/runcom/.bash_profile" ~
ln -sfv "$DOTFILES_DIR/runcom/.profile" ~
ln -sfv "$DOTFILES_DIR/git/.gitconfig" ~
ln -sfv "$DOTFILES_DIR/git/.gitignore_global" ~

echo "<<<<<< Removing unwanted packages"

sudo apt autoremove -y

echo "<<<<<< That's it!"