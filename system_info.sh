#!/usr/bin/bash


. ./lib/logger.sh


function mysystem_info() {
    if [ $# -eq 0 ]; then
        log_warning "No argument were passed."
        exit 1
    fi

    for myargs in "$@"; do
        # Kernel version
        if [ $myargs = 'kernel' ]; then
            log_success "Your Kernel version is: $(uname -r)"
        fi
        # Os type
        if [ $myargs = 'os' ]; then
            log_success "Your Os type is: $(uname -s)"
        fi
        # Distro version
        if [ $myargs = 'distro' ]; then
            log_success "Your Distro version is: $(cat /proc/sys/kernel/version)"
        fi
        # Platform
        if [ $myargs = 'platform' ]; then
            log_success "Your Platform version is: $(uname -m)"
        fi
    done
}


function main() {
    mysystem_info $1
}


main $1
