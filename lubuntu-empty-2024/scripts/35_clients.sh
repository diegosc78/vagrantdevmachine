#!/bin/bash

#----- VARIABLES -----#
DO_INSTALL_SQUIRREL=true
DO_INSTALL_SOAPUI=true
DO_INSTALL_POSTMAN=true
DO_INSTALL_MQTTEXPLORER=false
DO_INSTALL_NGROK=false
DO_INSTALL_REMMINA=true
DO_INSTALL_ZOOM=true
DO_INSTALL_FORTICLIENT=true
FORTICLIENT_VERSION="7.2"

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
    if [ "$DO_INSTALL_SQUIRREL" = true ] ; then
        show_info "Installing squirrel SQL client... "
        apt-get install -y -q snapd
        snap install squirrelsql
    fi
}

inst_soapui() {
    if [ "$DO_INSTALL_SOAPUI" = true ] ; then
        show_info "Installing soapui in /opt... "
        cd /opt
        wget https://s3.amazonaws.com/downloads.eviware/soapuios/5.5.0/SoapUI-5.5.0-linux-bin.tar.gz
        tar xvfz SoapUI-5.5.0-linux-bin.tar.gz
        rm SoapUI-5.5.0-linux-bin.tar.gz
    fi
}

inst_postman() {
    if [ "$DO_INSTALL_POSTMAN" = true ] ; then
        show_info "Installing postman... "
        apt-get install -y -q snapd
        snap install postman
    fi
}

inst_mqttexplorer() {
    if [ "$DO_INSTALL_MQTTEXPLORER" = true ] ; then
        show_info "Installing mqtt-explorer... "
        apt-get install -y -q snapd
        snap install mqtt-explorer
    fi
}

inst_rocketchat() {
    show_info "Installing rocket.chat... "
    apt-get install -y -q snapd
    snap install rocketchat-desktop
}

inst_ngrok(){
    if [ "$DO_INSTALL_NGROK" = true ] ; then
        show_info "Installing ngrok... "
        apt-get install -y -q snapd
        snap install ngrok
    fi
}

inst_jmeter(){
    if [ "$DO_INSTALL_JMETER" = true ] ; then
        show_info "Installing jmeter in /opt... "
        cd /opt
        wget https://dlcdn.apache.org//jmeter/binaries/apache-jmeter-5.6.3.zip
        unzip apache-jmeter-5.6.3.zip
        rm apache-jmeter-5.6.3.zip
    fi
}

inst_zoom() {
    if [ "$DO_INSTALL_ZOOM" = true ] ; then
        show_info "Installing zoom client... "
        sys_download zoom_amd64.deb https://cdn.zoom.us/prod/5.17.11.3835/zoom_amd64.deb
        apt -y install ./zoom_amd64.deb
        rm -f zoom_amd64.deb
    fi
}

inst_remmina() {
    if [ "$DO_INSTALL_REMMINA" = true ] ; then
        show_info "Installing remmina... "
        sys_install_package remmina remmina-plugin-rdp remmina-plugin-vnc remmina-plugin-secret
    fi
}

inst_forticlient() {
    if [ "$DO_INSTALL_FORTICLIENT" = true ] ; then
        show_info "Installing forticlient... "
        wget -O - https://repo.fortinet.com/repo/forticlient/${FORTICLIENT_VERSION}/debian/DEB-GPG-KEY | gpg --dearmor | sudo tee /usr/share/keyrings/repo.fortinet.com.gpg
        echo "deb [arch=amd64 signed-by=/usr/share/keyrings/repo.fortinet.com.gpg] https://repo.fortinet.com/repo/forticlient/${FORTICLIENT_VERSION}/debian/ stable non-free" | tee /etc/apt/sources.list.d/fortinet.list
        apt-get -y update && apt-get -y install forticlient
    fi
}


## MAIN
inst_squirrel
inst_soapui
inst_postman
inst_mqttexplorer
inst_ngrok
#inst_jmeter
inst_zoom
inst_remmina
inst_forticlient
