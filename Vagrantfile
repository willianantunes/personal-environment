# -*- mode: ruby -*-
# vi: set ft=ruby :

$dotfiles = "/home/vagrant/.dotfiles"
$my_email = "the-email-you-use-for-github"
$my_passphrase = "some-passphrase-that-makes-sense-to-you"
$env_vars = {"MY_PROVIDED_EMAIL" => $my_email, "MY_PROVIDED_PASSPHRASE" => $my_passphrase}

Vagrant.configure("2") do |config|
  # Official image if you'd like to create your own: config.vm.box = "ubuntu/focal64"
  config.vm.box = 'peru/ubuntu-20.04-desktop-amd64'
  # https://www.vagrantup.com/docs/synced-folders/basic_usage
  config.vm.synced_folder ".", $dotfiles, create: true, disabled: false

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = "4"
  end

  # https://www.vagrantup.com/docs/provisioning/shell
  # Update and upgrade the system
  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    bash #{$dotfiles}/src/utils/update_os.sh
  SHELL
  # Must have packages
  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    bash #{$dotfiles}/src/utils/must_have_packages.sh
  SHELL
  # Setup for my personal preferences and installation of many language managers
  config.vm.provision "shell", env: $env_vars, privileged: false, inline: <<-SHELL
    bash #{$dotfiles}/src/scripts/configure_dotfiles.sh
    bash #{$dotfiles}/src/scripts/languages_and_related_tools.sh
  SHELL
end
