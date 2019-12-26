#!/bin/bash

source ./commonFunctions.sh

inst_libreoffice() {
    show_info "Installing libreoffice... "
    apt-get -y install libreoffice
}

inst_dgrmodelio() {
    show_info "Installing modelio dgr tool... "
    cd ~
    sys_download https://iweb.dl.sourceforge.net/project/modeliouml/4.0.0/modelio-open-source4.0_4.0.0_amd64.deb
    apt-get install modelio-open-source4.0_4.0.0_amd64.deb
    rm modelio-open-source4.0_4.0.0_amd64.deb
}

inst_dgryed() {
    show_info "Installing yed dgr tool in /opt... "
    cd /opt
    sys_download https://www.yworks.com/resources/yed/demo/yEd-3.19.1.1.zip
    unzip yEd-3.19.1.1.zip
    rm yEd-3.19.1.1.zip
}

#TODO balsamiq

## MAIN
inst_libreoffice
inst_dgrmodelio
inst_dgryed


