#!/usr/bin/bash

. ./lib/logger.sh


function update_packages() {
    sudo apt-get update |& tee -a "$control_file" &> /dev/null
    sudo apt-get upgrade -y |& tee -a "$control_file" &> /dev/null
    log_success "Update has been completed."
}


function check_install() {
    if [ $# -eq 0 ]; then
        log_warning "No argument were given!"
        exit 1
    fi

    for package in "$@"; do
        dpkg -s "$package" &> /dev/null
        if [ $? -eq 0 ]; then
            log_info "Package ${package} is already installed."
        else
            log_info "Package ${package} is not installed."
            log_debug "Installing package ${package}..."
            sudo apt-get install -y "$package" | tee -a "$control_file" &> /dev/null
            if [ $? -eq 0 ]; then
                log_success "Package ${package} has been instaled succesfully"
            else
                log_error "Something went wrong. Check controll file ${control_file}."
            fi
        fi
    done
}


function main() {
    log_success "Control file ${UWHITE}${control_file}${NC} created."
    update_packages
    check_install ifconfig
}


main
