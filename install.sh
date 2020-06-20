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

source .dotfiles/personal_environment/utils.sh
source .dotfiles/personal_environment/must_have_packages.sh
source .dotfiles/personal_environment/workspace.sh
source .dotfiles/personal_environment/specific_for_virtual_machine.sh
source .dotfiles/personal_environment/apps.sh
source .dotfiles/personal_environment/software_engineering_packages.sh
source .dotfiles/personal_environment/dotfiles.sh

ask_for_sudo_as_needed

echo "###### Refreshing repository index"

sudo apt-get update

echo "###### Now doing the real thing!"

install_must_have_packages
create_development_workspace
DEV_WORKSPACE_TOOLS=$(create_development_workspace)
do_stuff_for_virtual_machines
install_basic_apps
install_software_engineering_tools $DEV_WORKSPACE_TOOLS

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
setup_dotfiles $DOTFILES_DIR

echo "###### That's it!"
