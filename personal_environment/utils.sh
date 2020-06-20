function ask_for_sudo_as_needed() { # https://github.com/alrra/dotfiles/blob/7311ef50b65495e89c7dd98fa927e5dfa5ee442b/src/os/utils.sh#L20
  # Ask for the administrator password upfront.
  sudo -v &>/dev/null

  # Update existing `sudo` time stamp
  # until this script has finished.
  #
  # https://gist.github.com/cowboy/3118588
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done &>/dev/null &
}

YES_REGEXP="^([yY][eE][sS]|[yY])$"
