#!/bin/bash

#----- Fancy Messages -----#
show_error(){
    echo -e "\033[1;31m *** $@ ***\033[m" 1>&2
}
show_info(){
    echo -e "\033[1;32m *** $@ ***\033[0m"
}
show_warning(){
    echo -e "\033[1;33m *** $@ ***\033[0m"
}
show_question(){
    echo -e "\033[1;34m *** $@ ***\033[0m"
}
show_success(){
    echo -e "\033[1;35m *** $@ ***\033[0m"
}
show_header(){
    echo -e "\033[1;36m *** $@ ***\033[0m"
}
show_listitem(){
    echo -e "\033[0;37m *** $@ ***\033[0m"
}


#----- System common functions -----#
sys_sudocheck() {
    if [ $(id -u) -ne 0 ]; then
        echo -e "Command must be run as root. Try 'sudo $1'\n"
        exit 1
    fi
}

sys_wait_for_apt_lock(){
	until sudo apt-get --yes update; do echo "Waiting for apt lock..."; sleep 5; done
}

sys_full_upgrade(){
	apt-get -y update && apt-get -y upgrade && apt-get -y dist-upgrade && apt-get -y autoremove && apt-get -y update
}	

sys_cleanup(){
	apt-get -y update && apt-get -y autoremove && apt-get -y clean && apt-get -y update
}	

sys_download(){
    local url=$2
    local file=$1
    wget --progress=dot $url >/dev/null 2>&1
}

sys_install_package(){
    local packages=$*
    sudo apt-get install -y $packages >/dev/null 2>&1
}

#------ Custom functions ----------#

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
    add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
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
inst_compose
