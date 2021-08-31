# Dotfiles for my personal work environment

This project is designed to work with [Ubuntu 20.04 LTS (Focal Fossa) builds](https://app.vagrantup.com/ubuntu/boxes/focal64). It has everything I require to develop. Although it installs everything I need, maybe some steps are necessary afterward (let's say log in on my Jetbrains account).

If you'd like to use it, it's better to check this project out and remove configurations made exclusively for me. I have no intention to make it generic enough to be used by anybody, though you can freely copy it.

## Installation directly on the host machine

To install it in a new machine, simply execute:

```shell
git clone https://github.com/willianantunes/personal-environment.git ~/.dotfiles
bash src/install.sh
```

## Using Vagrant

You must have Vagrant with VirtualBox for this option to work as expected. Then, you just need to run the following from your terminal:

```shell
vagrant up
```

If you're testing the installation script, you can use [snapshot](https://www.vagrantup.com/docs/cli/snapshot#snapshot) to rollback if something goes wrong. First you take a snapshot:

```shell
vagrant snapshot save start_point
```

Then you can go back in time to `start_point` again:

```shell
vagrant snapshot restore start_point
```

If a restart is required, you can do directly on the VM or issuing the following command:

```shell
vagrant reload
```

## Working with the Vagrantfile

You should open it as a Ruby file.

## Projects you should look at

Vagrant stuff:

- [felipecrs/dev-ubuntu](https://github.com/felipecrs/dev-ubuntu)
- [felipecrs/my-dev-ubuntu](https://github.com/felipecrs/my-dev-ubuntu)
- [ruzickap/packer-templates](https://github.com/ruzickap/packer-templates/)
- [UnderGrounder96/dev_OS](https://github.com/UnderGrounder96/dev_OS)
- [vccw-team/vccw](https://github.com/vccw-team/vccw)
- [Vagrant Cheat Sheet](https://gist.github.com/wpscholar/a49594e2e2b918f4d0c4)

Shell:

- [felipecrs/dotfiles](https://github.com/felipecrs/dotfiles)
- [Your unofficial guide to dotfiles on GitHub](https://dotfiles.github.io/)
- [alrra/dotfiles](https://github.com/alrra/dotfiles)
- [webpro/awesome-dotfiles](https://github.com/webpro/awesome-dotfiles)
- [donnemartin/dev-setup](https://github.com/donnemartin/dev-setup)
- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)
- [Canivete Suíço do Shell](http://aurelio.net/shell/canivete/)
- [fredcamps/dev-env](https://github.com/fredcamps/dev-env)
