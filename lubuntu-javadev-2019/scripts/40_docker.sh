#!/bin/bash

source ./commonFunctions.sh

COMPOSE_VERSION=1.25.0

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
    apt-get -y remove docker docker-engine docker.io containerd runc
    apt-get -y update
    apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt-get -y update
    apt-get -y install docker-ce docker-ce-cli containerd.io
    docker run hello-world
    groupadd docker
    usermod -aG docker $USER
    chown "$USER":"$USER" /home/"$USER"/.docker -R
    chmod g+rwx "$HOME/.docker" -R
    docker run hello-world
    systemctl enable docker
    docker -v
}

inst_compose() {
    show_info "Installing docker compose... "
    export DEBIAN_FRONTEND=noninteractive
    curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    docker-compose -v
}

## MAIN
inst_docker_amd64

