# Dotfiles for my personal work environment

This was tested on a Ubuntu 20.04 virtual machine. Follow the steps below to run it:

    git clone https://github.com/willianantunes/personal-environment.git ~/.dotfiles
    bash ~/.dotfiles/install.sh 2>&1 | tee -a ~/.dotfiles/install.log

If you want to test right away if it's OK the [`.exports`](system/.exports), try to run it from the following command below instead of restarting your session:

    source ~/.bash_profile
    
## Testing environment

Save a snapshot, update your script and then execute:

    git clone https://github.com/willianantunes/personal-environment.git && \
    mv personal-environment ~/.dotfiles && cd ~/.dotfiles && \
    git checkout YOUR-TESTING-BRANCH && cd .. && \
    bash ~/.dotfiles/install.sh 2>&1 | tee -a ~/.dotfiles/install.log

If something bad happens, return your snapshot, update your script and repeat the process.

## Next steps

I work with IntelliJ IDEA to do my daily job, so regarding it and other stuff:

- Install Jetbrains Toolbox App
- Trigger IntelliJ IDEA Ultimate installation
- Check if some stuff is installed or not to avoid errors
- Use native helpers to avoid "reinvent the wheel" process

## Useful links

- [How to Fix ‘E: Could not get lock /var/lib/dpkg/lock’ Error in Ubuntu Linux](https://itsfoss.com/could-not-get-lock-error/)
