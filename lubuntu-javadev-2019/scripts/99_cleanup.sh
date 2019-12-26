#!/bin/bash

source ./commonFunctions.sh

cleanup_bash() {
    cat /dev/null > ~/.bash_history && history -c && exit
}

## MAIN
sys_wait_for_apt_lock
sys_cleanup
cleanup_bash

