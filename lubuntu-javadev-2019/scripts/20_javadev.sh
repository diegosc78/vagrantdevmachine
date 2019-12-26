#!/bin/bash

source ./commonFunctions.sh

inst_javabuildtools() {
    show_info "Installing cli java build tools... "
    sys_wait_for_apt_lock
    apt-get -y install maven ant
}

inst_oracle_java8() {
    show_info "Installing Oracle Java8... "
    sys_wait_for_apt_lock
    add-apt-repository -y ppa:webupd8team/java
    apt-get -y update
    echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
    echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
    apt-get -y install oracle-java8-installer
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
    sys_wait_for_apt_lock
    add-apt-repository -y ppa:vajdics/netbeans-installer
    apt-get -y install netbeans-installer    
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
inst_idenetbeans
inst_ideintellij
