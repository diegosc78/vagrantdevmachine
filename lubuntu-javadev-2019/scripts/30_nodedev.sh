#!/bin/bash

source ./commonFunctions.sh

inst_node() {
    show_info "Installing node... "
    apt-get install curl python-software-properties
    curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
    apt-get -y install nodejs
    nodejs -v
    npm -v    
}

inst_nodebuildtools() {
    show_info "Installing node build tools... "
    npm install -g eslint
    npm install -g grunt-cli
}

## MAIN
inst_node
inst_nodebuildtools

