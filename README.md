# Dotfiles for my personal work environment

This was tested on a Ubuntu 18.04 virtual machine. Follow the steps below to run it:

    git clone https://github.com/willianantunes/personal-environment.git ~/.dotfiles
    bash ~/.dotfiles/install.sh 2>&1 | tee -a ~/.dotfiles/install.log

If you want to test right away if it's OK the [`.exports`](system/.exports), try to run it from the following command below instead of restarting your session:

    source ~/.bash_profile

## Next steps

I work with IntelliJ IDEA to do my daily job, so regarding it and other stuff:

- Install Jetbrains Toolbox App
- Trigger IntelliJ IDEA Ultimate installation
- Install plugins for IDEA like BashSupport, Lombok Plugin and Maven Helper
- Custom IDE configuration for IDEA
- Check if some stuff is installed or not to avoid errors