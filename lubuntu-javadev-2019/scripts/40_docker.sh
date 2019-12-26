#!/bin/bash

source ./commonFunctions.sh

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

inst_compose() {
    show_info "Installing docker compose... "
    export DEBIAN_FRONTEND=noninteractive
    sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
}

## MAIN
inst_docker_amd64

