function setup_dotfiles() {
  echo "<<<<<< Dotfiles"

  DOTFILES_DIR=$1

  ln -sfv "$DOTFILES_DIR/runcom/.bash_profile" ~
  ln -sfv "$DOTFILES_DIR/runcom/.profile" ~
  ln -sfv "$DOTFILES_DIR/git/.gitconfig" ~
  ln -sfv "$DOTFILES_DIR/git/.gitignore_global" ~
}
