#!/bin/bash

#----- VARIABLES -----#
DO_INSTALL_JAVA=false
DO_INSTALL_NODE=false
DO_INSTALL_VSCODE=true
DO_INSTALL_INTELLIJ=false
JAVA_VERSION="17"
NODE_VERSION=18

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

inst_openjdk_java() {
    if [ "$DO_INSTALL_JAVA" = true ] ; then
        show_info "Installing OpenJDK Java $1 and Maven... "
        local version=$1
        sys_wait_for_apt_lock
        apt-get install -y openjdk-$version-jdk maven >/dev/null 2>&1;
        java -version
    fi    
}

inst_node() {
    if [ "$DO_INSTALL_NODE" = true ] ; then
        show_info "Installing NodeJS... "
        sys_wait_for_apt_lock
        curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | sudo -E bash -
        apt install -y nodejs
        node --version
        npm --version
    fi    
}

inst_vscode() {
    if [ "$DO_INSTALL_VSCODE" = true ] ; then
        show_info "Installing VSCode... "
        sys_wait_for_apt_lock
        curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
        install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
        sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
        apt-get -y update && apt-get -y install code
        rm -f microsoft.gpg
    fi    
}

inst_intellij() {
    if [ "$DO_INSTALL_INTELLIJ" = true ] ; then
        show_info "Installing IDE intellij... "
        apt-get install -y -q snapd
        snap install intellij-idea-community --classic
    fi    
}


#------ MAIN ----------#

inst_openjdk_java $JAVA_VERSION
inst_node
inst_vscode
inst_intellij
