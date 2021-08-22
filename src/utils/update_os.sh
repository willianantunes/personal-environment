#!/usr/bin/env bash

# https://www.willianantunes.com/blog/2021/05/production-ready-shell-startup-scripts-the-set-builtin/
set -eux -o pipefail

source "${BASH_SOURCE%/*}/helpers.sh"

"${APT_GET[@]}" update
# If you uncomment the `dist-upgrade` below, you'll receive the following errors after you do the provisioning followed by `vagrant reload`:
# - mount[657]: /sbin/mount.vboxsf: mounting failed with the error: Invalid argument
# - udisksd[356]: failed to load module mdraid: libbd_mdraid.so.2: cannot open shared object file: No such file or directory
# Possible solution: https://stackoverflow.com/a/23752848
# "${APT_GET[@]}" -yq dist-upgrade

# Locale PT-BR
"${APT_GET_INSTALL[@]}" language-pack-gnome-pt-base language-pack-gnome-pt language-pack-pt-base language-pack-pt

# Set keyboard layout to Portuguese (Brazil)
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'br')]"

# Set timezone to America/Sao_Paulo
sudo rm -f /etc/localtime
sudo ln -s /usr/share/zoneinfo/America/Sao_Paulo  /etc/localtime
