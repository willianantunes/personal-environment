function install_must_have_packages() {
  echo "<<<<<< Utility and must-have packages"

  sudo apt install -y -q vim \
  tree \
  nano \
  gnome-disk-utility \
  gdebi-core \
  build-essential libssl-dev \
  zlib1g-dev libbz2-dev libsqlite3-dev \
  wget curl llvm \
  libncurses5-dev libncursesw5-dev \
  xz-utils tk-dev libffi-dev liblzma-dev python-openssl \
  apt-transport-https ca-certificates software-properties-common
}
