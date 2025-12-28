#!/bin/bash

#----- VARIABLES -----#
DO_INSTALL_HELM=true
DO_INSTALL_KUBECTL=true
DO_INSTALL_K9S=true

KUBECTL_VERSION=v1.28

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

inst_k8scli() {
    show_info "Installing K8s client tools... "
    sys_wait_for_apt_lock
    mkdir -p ~/.kube

    if [ "$DO_INSTALL_HELM" = true ] ; then
        show_info "Installing helm... "
        curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | tee /usr/share/keyrings/helm.gpg > /dev/null
        apt-get install apt-transport-https --yes
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
        apt-get -y update && apt-get -y install helm
        helm version
    fi    

    if [ "$DO_INSTALL_KUBECTL" = true ] ; then
        show_info "Installing kubectl... "
        curl -fsSL https://pkgs.k8s.io/core:/stable:/${KUBECTL_VERSION}/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
        chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring    
        echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${KUBECTL_VERSION}/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
        chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly    
        apt-get -y update && apt-get -y install kubectl
        kubectl version
    fi    

    if [ "$DO_INSTALL_K9S" = true ] ; then
        show_info "Installing k9s... "
        apt-get install -y -q snapd
        snap install k9s --channel=latest/stable
        ln -s /snap/k9s/current/bin/k9s /snap/bin/
        k9s version
    fi    
}


#------ MAIN ----------#

inst_k8scli
