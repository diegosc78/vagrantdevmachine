# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  #config.vm.box = "ubuntu/trusty64"
  config.vm.box = "ubuntu/xenial64"

  # config.vm.network "forwarded_port", guest: 80, host: 8080
  # config.vm.network "private_network", ip: "192.168.33.10"
  # config.vm.network "public_network"
  config.vm.synced_folder ".", "/host"

  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = true
    # Customize the amount of memory on the VM:
    vb.memory = "4096"
    # Nombre
    vb.name = "devdockerhost_0321"
  end

  config.vm.provision "file", source: "ubuntu.sh", destination: "/tmp/ubuntu.sh"
  config.vm.provision "file", source: "docker-compose.yaml", destination: "/tmp/docker-compose.yaml"

  config.vm.provision "shell", path: "ubuntu.sh"

  config.vm.provision "docker" do |d|
    d.pull_images "tomcat"
    d.run "selenium-hub", args: "-p 4444:4444", image: "selenium/hub"
    d.run "selenium-node-ff", args: "--link selenium-hub:hub", image: "selenium/node-firefox"
    d.run "selenium-node-ch", args: "--link selenium-hub:hub", image: "selenium/node-chrome"

  end

  config.vm.provision :shell, inline: 'reboot'

end
