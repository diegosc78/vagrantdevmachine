#!/bin/bash

echo "[ubuntu.sh] Creating alternative user..."
adduser --disabled-password --gecos "" vagrant sudo
echo -e "ubuntu:ubuntu\nvagrant:vagrant" | sudo chpasswd

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
apt-get -y install netbeans-installer

echo "[ubuntu.sh] Installing graphic tools... "
apt-get -y install firefox filezilla lxterminal gedit gimp sublime-text-installer keepass2 meld

echo "[ubuntu.sh] Installing jenkins... "
wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
apt-get update
apt-get -y install jenkins
usermod -G docker jenkins
# JENKINS 8080



echo "[ubuntu.sh] Installing mysql-server... "
sudo debconf-set-selections <<< 'mysql-server-5.7 mysql-server/root_password password Change.1t'
sudo debconf-set-selections <<< 'mysql-server-5.7 mysql-server/root_password_again password Change.1t'
sudo apt-get -y install mysql-server-5.7

echo "[ubuntu.sh] Installing sonar... "
Q1="CREATE DATABASE IF NOT EXISTS sonarqube;"
Q2="GRANT USAGE ON *.* TO sonarqube@localhost IDENTIFIED BY 'Change.1t';"
Q3="GRANT ALL PRIVILEGES ON sonarqube.* TO sonarqube@localhost;"
Q4="FLUSH PRIVILEGES;"
SQL="${Q1}${Q2}${Q3}${Q4}"
mysql -uroot -pChange.1t -e "$SQL"
sh -c 'echo deb http://downloads.sourceforge.net/project/sonar-pkg/deb binary/ > /etc/apt/sources.list.d/sonarqube.list'
apt-get update && apt-get -y --allow-unauthenticated install sonar

sudo -u sonar bash
echo "#VAGRANT AUTO CFG" >> /opt/sonar/conf/sonar.properties
echo "sonar.jdbc.username=sonarqube" >> /opt/sonar/conf/sonar.properties
echo "sonar.jdbc.password=Change.1t" >> /opt/sonar/conf/sonar.properties
echo "sonar.jdbc.url=jdbc:mysql://localhost:3306/sonarqube?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true&useConfigs=maxPerformance" >> /opt/sonar/conf/sonar.properties
update-rc.d sonar defaults
service sonar start
# SONAR 9000: admin/admin

echo "[ubuntu.sh] Installing nexus... "
nexus_tarball=latest-unix.tar.gz
nexus_download_url=http://download.sonatype.com/nexus/3/$nexus_tarball
groupadd --system nexus
adduser \
    --system \
    --disabled-login \
    --no-create-home \
    --gecos '' \
    --ingroup nexus \
    --home /opt/nexus \
    nexus
install -d -o root -g nexus -m 750 /opt/nexus
pushd /opt/nexus
wget -q $nexus_download_url
tar xf $nexus_tarball --strip-components 1
rm $nexus_tarball
chmod 700 nexus3
chown -R nexus:nexus nexus3
chmod 700 etc
chown -R nexus:nexus etc # for some reason karaf changes files inside this directory. TODO see why.
install -d -o nexus -g nexus -m 700 .java # java preferences are saved here (the default java.util.prefs.userRoot preference).
cp -p etc/{nexus-default.properties,nexus.properties}
sed -i -E 's,(application-host=).+,\1127.0.0.1,g' etc/nexus.properties
sed -i -E 's,nexus-pro-,nexus-oss-,g' etc/nexus.properties
sed -i -E 's,\.\./sonatype-work/,,g' bin/nexus.vmoptions
echo -e "\nrun_as_user=nexus" >> bin/nexus.rc

popd

cat >/etc/systemd/system/nexus.service <<'EOF'
[Unit]
Description=Nexus
After=network.target
[Service]
Type=simple
User=nexus
Group=nexus
ExecStart=/opt/nexus/bin/nexus run
WorkingDirectory=/opt/nexus
Restart=always
[Install]
WantedBy=multi-user.target
EOF
systemctl enable nexus
systemctl start nexus

# configure nexus with the groovy script.
#bash /vagrant/provision/execute-provision.groovy-script.sh

# NEXUS 8081: admin/admin123



# clean packages.
apt-get -y autoremove
apt-get -y clean


