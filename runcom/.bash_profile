# Resolve DOTFILES_DIR

if [ -d "$HOME/.dotfiles" ]; then
  DOTFILES_DIR="$HOME/.dotfiles"
else
  echo "<<<<<< Unable to find dotfiles, exiting"
  return
fi

# Source the dotfiles

for DOTFILE in "$DOTFILES_DIR"/system/.{exports,aliases,functions,extra}; do
    [ -r "$DOTFILE" ] && [ -f "$DOTFILE" ] && source "$DOTFILE";
done

# Clean up

unset DOTFILE