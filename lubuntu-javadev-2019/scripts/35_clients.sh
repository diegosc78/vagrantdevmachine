#!/bin/bash

source ./commonFunctions.sh

inst_squirrel() {
    show_info "Installing squirrel SQL client... "
    sys_wait_for_apt_lock
    snap install squirrelsql
}

inst_soapui() {
    show_info "Installing soapui in /opt... "
    cd /opt
    sys_download https://s3.amazonaws.com/downloads.eviware/soapuios/5.5.0/SoapUI-5.5.0-linux-bin.tar.gz
    tar xvfz SoapUI-5.5.0-linux-bin.tar.gz
    rm SoapUI-5.5.0-linux-bin.tar.gz
}

inst_mqttexplorer() {
    show_info "Installing mqtt-explorer... "
    snap install mqtt-explorer
}

inst_rocketchat() {
    show_info "Installing rocket.chat... "
    snap install rocketchat-desktop
}

## MAIN
inst_squirrel
inst_soapui
inst_mqttexplorer
inst_rocketchat