#!/bin/bash

VBOX_VERSION=

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

inst_guestadditions() {
    show_info "Installing VirtualBox Guest Additions..."
    sys_wait_for_apt_lock
    apt-get --yes update && apt-get --yes install gcc make perl

    local VBOX_ISO=VBoxGuestAdditions_$VBOX_VERSION.iso
    mount -o loop ${VBOX_ISO} /mnt
    /mnt/VBoxLinuxAdditions.run
    umount /mnt
    rm -rf /home/vagrant/${VBOX_ISO}
}

setup_spanish() {
    show_info "Installing languages for ES... "
    until sudo apt-get --yes update; do echo "Waiting for apt lock..."; sleep 5; done
    # cd /usr/share/locales/ && sudo ./install-language-pack es_ES
    apt-get -y install language-pack-es language-pack-es-base

    show_info "Configuring languages for ES... "
    # locale-gen "es_ES.UTF-8";
    echo "locales locales/default_environment_locale select es_ES.UTF-8" | debconf-set-selections
    dpkg-reconfigure -f noninteractive locales
    update-locale LC_ALL=es_ES.UTF-8 LANG=es_ES.UTF-8;

    #show_info "Installing console data... "
    #apt-get -y install console-data
    #sudo dpkg-reconfigure console-data

    show_info "Configuring keyboard for ES... "
    #echo "keyboard-configuration keyboard-configuration/model select PC genérico 105 teclas (intl)" | debconf-set-selections
    #echo "keyboard-configuration keyboard-configuration/modelcode string pc105" | debconf-set-selections
    #echo "keyboard-configuration keyboard-configuration/layout select Español" | debconf-set-selections
    #echo "keyboard-configuration keyboard-configuration/layoutcode string es" | debconf-set-selections
    #echo "keyboard-configuration keyboard-configuration/variant select Español" | debconf-set-selections
    #echo "keyboard-configuration keyboard-configuration/variantcode string deadtilde" | debconf-set-selections
    #echo "keyboard-configuration keyboard-configuration/xkb-keymap select es" | debconf-set-selections
    sudo sed -i 's|XKBLAYOUT=....|XKBLAYOUT="'es'"|g' /etc/default/keyboard
    dpkg-reconfigure -f noninteractive keyboard-configuration
    #dpkg-reconfigure console-setup

    show_info "Configuring timezone for ES... "
    echo "tzdata tzdata/Areas select Europe" | debconf-set-selections
    echo "tzdata tzdata/Zones/Europe select Madrid" | debconf-set-selections
    dpkg-reconfigure -f noninteractive tzdata
}

inst_clihttpclients() {
    show_info "Installing cli http client tools... "
    sys_wait_for_apt_lock
    apt-get -y install curl wget apt-transport-https ca-certificates gnupg-agent software-properties-common make build-essential gnupg2
}

inst_clicompressors() {
    show_info "Installing cli compressor tools... "
    sys_wait_for_apt_lock
    apt-get -y install zip unzip unrar rar p7zip-full
}

inst_cliversioncontroltools() {
    show_info "Installing cli version control tools... "
    sys_wait_for_apt_lock
    apt-get -y install git stow subversion
}

inst_clieditors() {
    show_info "Installing cli editor tools... "
    sys_wait_for_apt_lock
    apt-get -y install nano vim sed
}

inst_guitools() {
    show_info "Installing gui basic tools... "
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
    sys_wait_for_apt_lock
    apt-get update -y
    apt-get -y install lxterminal terminator firefox google-chrome-stable filezilla keepass2 meld shutter putty xca

    add-apt-repository ppa:unit193/encryption
    apt-get update -y
    apt-get -y install veracrypt

    wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | apt-key add -
    echo "deb http://deb.anydesk.com/ all main" | tee /etc/apt/sources.list.d/anydesk-stable.list
    apt-get update -y
    apt-get -y install anydesk
}

inst_lxde() {
    show_info "Installing lxde... "
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
    apt-get install -y --quiet ttf-mscorefonts-installer
    apt-get -y install lubuntu-core lubuntu-icon-theme lubuntu-restricted-extras language-pack-gnome-es
}


## MAIN
sys_full_upgrade
setup_spanish
#inst_guestadditions
inst_clihttpclients
inst_clicompressors
inst_cliversioncontroltools
inst_clieditors
inst_lxde
inst_guitools

