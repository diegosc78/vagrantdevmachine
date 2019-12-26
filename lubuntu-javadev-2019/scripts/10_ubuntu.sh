#!/bin/bash

source ./commonFunctions.sh

inst_guestadditions() {
    show_info "Installing VirtualBox Guest Additions..."
    sys_wait_for_apt_lock
    apt-get --yes update && apt-get --yes install gcc make perl

    local VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
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
    apt-get -y install curl wget apt-transport-https ca-certificates gnupg-agent software-properties-common
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
    sys_wait_for_apt_lock
    apt-get -y install lxterminal terminator firefox filezilla keepass2 meld

    add-apt-repository -y ppa:webupd8team/sublime-text-3
    apt-get -y install sublime-text-installer
}

inst_lxde() {
    show_info "Installing lxde... "
    apt-get -y install lubuntu-core lubuntu-icon-theme lubuntu-restricted-extras language-pack-gnome-es
}


## MAIN
sys_full_upgrade
setup_spanish
inst_guestadditions
inst_clihttpclients
inst_clicompressors
inst_cliversioncontroltools
inst_clieditors
inst_lxde
inst_guitools

