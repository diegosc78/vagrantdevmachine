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

inst_squirrel() {
    show_info "Installing squirrel SQL client... "
    apt-get install -y -q snapd
    snap install squirrelsql
}

inst_soapui() {
    show_info "Installing soapui in /opt... "
    cd /opt
    wget https://s3.amazonaws.com/downloads.eviware/soapuios/5.5.0/SoapUI-5.5.0-linux-bin.tar.gz
    tar xvfz SoapUI-5.5.0-linux-bin.tar.gz
    rm SoapUI-5.5.0-linux-bin.tar.gz
}

inst_postman() {
    show_info "Installing postman... "
    apt-get install -y -q snapd
    snap install postman
}

inst_mqttexplorer() {
    show_info "Installing mqtt-explorer... "
    apt-get install -y -q snapd
    snap install mqtt-explorer
}

inst_rocketchat() {
    show_info "Installing rocket.chat... "
    apt-get install -y -q snapd
    snap install rocketchat-desktop
}

inst_ngrok(){
    show_info "Installing ngrok... "
    apt-get install -y -q snapd
    snap install ngrok
}

inst_jmeter(){
    show_info "Installing jmeter in /opt... "
    cd /opt
    wget https://dlcdn.apache.org//jmeter/binaries/apache-jmeter-5.6.3.zip
    unzip apache-jmeter-5.6.3.zip
    rm apache-jmeter-5.6.3.zip
}

## MAIN
inst_squirrel
inst_soapui
inst_postman
inst_mqttexplorer
#inst_rocketchat
inst_ngrok
#inst_jmeter
