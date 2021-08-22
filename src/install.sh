#!/usr/bin/env bash

# https://www.willianantunes.com/blog/2021/05/production-ready-shell-startup-scripts-the-set-builtin/
set -eux -o pipefail

bash "${BASH_SOURCE%/*}/utils/update_os.sh"
bash "${BASH_SOURCE%/*}/utils/must_have_packages.sh"
bash "${BASH_SOURCE%/*}/scripts/configure_dotfiles.sh"
bash "${BASH_SOURCE%/*}/scripts/languages_and_related_tools.sh"
