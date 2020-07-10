function install_basic_apps() {
  echo "<<<<<< Basic applications"

  echo "<<< Chrome"

  [ -f google-chrome-stable_current_amd64.deb ] && echo "No need to execute again" || \
  curl -OL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&
    sudo gdebi --n google-chrome-stable_current_amd64.deb

  echo "<<< Wireshark"

  sudo apt install -y -q debconf-doc debconf-utils &&
    sudo DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true apt install -yq wireshark

  echo "<<< Graphical tools"

  sudo apt install -y -q gimp inkscape peek

  echo "<<< Networking"

  sudo apt install -y -q nmap net-tools putty
}
