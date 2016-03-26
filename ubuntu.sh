#!/bin/bash

echo "[ubuntu.sh] Update sources... "
apt-get -y update

echo "[ubuntu.sh] Installing languages for ES... "
# cd /usr/share/locales/ && sudo ./install-language-pack es_ES
apt-get -y install language-pack-es language-pack-es-base

echo "[ubuntu.sh] Configuring languages for ES... "
# locale-gen "es_ES.UTF-8";
echo "locales locales/default_environment_locale select es_ES.UTF-8" | debconf-set-selections
dpkg-reconfigure -f noninteractive locales
update-locale LC_ALL=es_ES.UTF-8 LANG=es_ES.UTF-8;

echo "[ubuntu.sh] Installing console data... "
#apt-get -y install console-data
#sudo dpkg-reconfigure console-data

echo "[ubuntu.sh] Configuring keyboard for ES... "
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

echo "[ubuntu.sh] Configuring timezone for ES... "
echo "tzdata tzdata/Areas select Europe" | debconf-set-selections
echo "tzdata tzdata/Zones/Europe select Madrid" | debconf-set-selections
dpkg-reconfigure -f noninteractive tzdata



#reboot
#localectl set-keymap --no-convert mapa_de_teclas


echo "[ubuntu.sh] Installing Basic command-line tools... "
apt-get -y install curl git-core unzip vim nano wget subversion unrar rar

echo "[ubuntu.sh] Installing LXDE... "
echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections
apt-get -y install lubuntu-core lubuntu-icon-theme lubuntu-restricted-extras language-pack-gnome-es


echo "[ubuntu.sh] Adding ppa repositories for devel tools... "
add-apt-repository -y ppa:webupd8team/java
add-apt-repository -y ppa:webupd8team/brackets
add-apt-repository -y ppa:webupd8team/sublime-text-3
add-apt-repository -y ppa:vajdics/netbeans-installer
apt-get -y update

echo "[ubuntu.sh] Installing oracle java... "
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
apt-get -y install oracle-java8-installer

echo "[ubuntu.sh] Installing java devel tools... "
apt-get -y install brackets maven ant
apt-get -y netbeans-installer

echo "[ubuntu.sh] Installing graphic tools... "
apt-get -y install firefox filezilla lxterminal gedit gimp sublime-text-installer keepass2 meld

#echo "[ubuntu.sh] Installing jenkins... "
#wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
#sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
#apt-get update
#apt-get -y install jenkins
#usermod -G docker jenkins

