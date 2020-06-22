function setup_dotfiles() {
  echo "<<<<<< Dotfiles"

  ln -sfv "$DOTFILES_DIR/runcom/.bash_profile" ~
  ln -sfv "$DOTFILES_DIR/runcom/.profile" ~
  ln -sfv "$DOTFILES_DIR/git/.gitconfig" ~
  ln -sfv "$DOTFILES_DIR/git/.gitignore_global" ~

  cat $DOTFILES_DIR/runcom/.profile >> .bashrc
}
