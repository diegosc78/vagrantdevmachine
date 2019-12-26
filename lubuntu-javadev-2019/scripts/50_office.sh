#!/bin/bash

source ./commonFunctions.sh

inst_libreoffice() {
    show_info "Installing libreoffice... "
    apt-get -y install libreoffice
}

inst_dgrmodelio() {
    show_info "Installing modelio dgr tool... "
#TODO NYI
}

inst_dgryed() {
    show_info "Installing yed dgr tool... "
#TODO NYI
}

#TODO balsamiq

## MAIN
inst_libreoffice
inst_dgrmodelio
inst_dgryed

