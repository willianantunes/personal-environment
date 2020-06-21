#!/bin/bash
#######################################################
# Description    : My honest install script to
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

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WHERE_AM_I="$(pwd)"

source $DOTFILES_DIR/personal_environment/settings.sh
source $DOTFILES_DIR/personal_environment/utils.sh
source $DOTFILES_DIR/personal_environment/must_have_packages.sh
source $DOTFILES_DIR/personal_environment/workspace.sh
source $DOTFILES_DIR/personal_environment/specific_for_virtual_machine.sh
source $DOTFILES_DIR/personal_environment/apps.sh
source $DOTFILES_DIR/personal_environment/software_engineering_packages.sh
source $DOTFILES_DIR/personal_environment/dotfiles.sh

ask_for_sudo_upfront

echo "###### Refreshing repository index"

sudo apt-get update

echo "###### Now doing the real thing!"

install_must_have_packages
create_development_workspace
do_stuff_for_virtual_machines
install_basic_apps
install_software_engineering_tools

setup_dotfiles $DOTFILES_DIR

echo "###### That's it!"
