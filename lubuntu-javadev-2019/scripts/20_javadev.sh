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

inst_javabuildtools() {
    show_info "Installing cli java build tools... "
    sys_wait_for_apt_lock
    apt-get -y install maven ant
}

inst_oracle_java8() {
    ## YA NO FUNCIONA !!!!
    show_info "Installing Oracle Java8... "
#    sys_wait_for_apt_lock
#    add-apt-repository -y ppa:webupd8team/java
#    apt-get -y update
#    echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
#    echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
#    apt-get -y install oracle-java8-installer

    cd /opt
    wget -c --content-disposition "https://javadl.oracle.com/webapps/download/AutoDL?BundleId=239835_230deb18db3e4014bb8e3e8324f81b43"

}

inst_openjdk_java() {
    show_info "Installing OpenJDK Java... "
    local version=$1
    sys_wait_for_apt_lock
    apt-get install -y openjdk-$version-jdk >/dev/null 2>&1;
    JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:/bin/java::")
#	ln -s ${JAVA_HOME} /usr/local/java
#	cp $JAVA_RES_SH /etc/profile.d/java.sh
#	source /etc/profile.d/java.sh
#	echo 'source /etc/profile.d/java.sh' >> /home/${USER}/.bashrc_local    
}

inst_ideintellij() {
    show_info "Installing IDE intellij... "
    apt-get install -y -q snapd
    snap install intellij-idea-community --classic
}

inst_idenetbeans() {
    show_info "Installing IDE netbeans... "
    apt-get install -y -q snapd
    snap install netbeans --classic
}

inst_idevscode() {
    show_info "Installing IDE vscode... "
    sys_wait_for_apt_lock
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
    sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    apt-get -y update
    apt-get -y install code
}

inst_ideeclipse() {
    show_info "Installing IDE eclipse... "
    apt-get install -y -q snapd
    snap install eclipse --classic
}

## MAIN
inst_openjdk_java "8"
inst_openjdk_java "11"
inst_oracle_java8
inst_javabuildtools
inst_idevscode
inst_ideintellij
inst_idenetbeans
inst_ideeclipse
