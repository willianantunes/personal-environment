#!/usr/bin/env bash

# https://www.willianantunes.com/blog/2021/05/production-ready-shell-startup-scripts-the-set-builtin/
set -eux -o pipefail

source "${BASH_SOURCE%/*}/settings.sh"

ln -sfv "$DOTFILES_DIR/src/profiles/.profile" ~
ln -sfv "$DOTFILES_DIR/src/custom/.gitconfig" ~
ln -sfv "$DOTFILES_DIR/src/custom/.gitignore_global" ~

WHERE_IS_BASHRC="$HOME/.bashrc"
WHERE_IS_ZSHRC="$HOME/.zshrc"
FILE_EVERY_I_SHELL="$DOTFILES_DIR/src/profiles/.executed_in_every_interactive_shell"
ENTRY_TO_BE_SAVED="\\n\\n. $FILE_EVERY_I_SHELL\\n"

! grep -q "$FILE_EVERY_I_SHELL" "$WHERE_IS_BASHRC" && command printf "${ENTRY_TO_BE_SAVED}" >> "$WHERE_IS_BASHRC"
! grep -q "$FILE_EVERY_I_SHELL" "$WHERE_IS_ZSHRC" && command printf "${ENTRY_TO_BE_SAVED}" >> "$WHERE_IS_ZSHRC"
