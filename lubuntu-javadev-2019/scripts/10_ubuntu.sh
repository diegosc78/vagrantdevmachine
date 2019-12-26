#!/bin/bash

source ./commonFunctions.sh

setup_spanish() {
    show_info "Installing languages for ES... "
    # cd /usr/share/locales/ && sudo ./install-language-pack es_ES
    apt-get -y install language-pack-es language-pack-es-base

    show_info "Configuring languages for ES... "
    # locale-gen "es_ES.UTF-8";
    echo "locales locales/default_environment_locale select es_ES.UTF-8" | debconf-set-selections
    dpkg-reconfigure -f noninteractive locales
    update-locale LC_ALL=es_ES.UTF-8 LANG=es_ES.UTF-8;

    #show_info "Installing console data... "
    #apt-get -y install console-data
    #sudo dpkg-reconfigure console-data

    show_info "Configuring keyboard for ES... "
    #echo "keyboard-configuration keyboard-configuration/model select PC genérico 105 teclas (intl)" | debconf-set-selections
    #echo "keyboard-configuration keyboard-configuration/modelcode string pc105" | debconf-set-selections
    #echo "keyboard-configuration keyboard-configuration/layout select Español" | debconf-set-selections
    #echo "keyboard-configuration keyboard-configuration/layoutcode string es" | debconf-set-selections
    #echo "keyboard-configuration keyboard-configuration/variant select Español" | debconf-set-selections
    #echo "keyboard-configuration keyboard-configuration/variantcode string deadtilde" | debconf-set-selections
    #echo "keyboard-configuration keyboard-configuration/xkb-keymap select es" | debconf-set-selections
    sudo sed -i 's|XKBLAYOUT=....|XKBLAYOUT="'es'"|g' /etc/default/keyboard
    dpkg-reconfigure -f noninteractive keyboard-configuration
    #dpkg-reconfigure console-setup

    show_info "Configuring timezone for ES... "
    echo "tzdata tzdata/Areas select Europe" | debconf-set-selections
    echo "tzdata tzdata/Zones/Europe select Madrid" | debconf-set-selections
    dpkg-reconfigure -f noninteractive tzdata
}


inst_clidevtools() {
    show_info "Installing basic command-line dev tools... "
    apt-get -y install curl git-core unzip vim nano wget subversion unrar rar
    add-apt-repository -y ppa:webupd8team/java
    apt-get -y update
    echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
    echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
    apt-get -y install oracle-java8-installer
    apt-get -y install maven ant
}

inst_guidevtools() {
    show_info "Installing basic gui dev tools... "
    add-apt-repository -y ppa:webupd8team/sublime-text-3
    add-apt-repository -y ppa:vajdics/netbeans-installer

    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
    sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    apt-get install apt-transport-https
    apt-get -y update

    apt-get -y install code
    apt-get -y install netbeans-installer

    apt-get -y install filezilla lxterminal sublime-text-installer keepass2 meld    
}

inst_node() {
    show_info "Installing node... "
    apt-get install curl python-software-properties
    curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
    apt-get -y install nodejs
    nodejs -v
    npm -v    
}

inst_ansible() {
    show_info "Installing ansible... "
    apt-get -y install curl software-properties-common
    apt-add-repository -y ppa:ansible/ansible && apt-get update
    apt-get -y install ansible
    echo "127.0.0.1" > /tmp/ansible_hosts
    ansible all -i /tmp/ansible_hosts -m ping
}

inst_docker_amd64() {
    show_info "Installing dockerCE... "
    sudo apt-get -y remove docker docker-engine docker.io containerd runc
    sudo apt-get -y update
    sudo apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get -y update
    sudo apt-get -y install docker-ce docker-ce-cli containerd.io
    sudo docker run hello-world
    sudo groupadd docker
    sudo usermod -aG docker $USER
    sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
    sudo chmod g+rwx "$HOME/.docker" -R
    docker run hello-world
    sudo systemctl enable docker
}

inst_lxde() {
    show_info "Installing lxde... "
    apt-get -y install lubuntu-core lubuntu-icon-theme lubuntu-restricted-extras language-pack-gnome-es
}


## MAIN
sys_full_upgrade
setup_spanish
inst_lxde

