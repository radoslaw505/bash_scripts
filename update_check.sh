#!/usr/bin/bash


LIB_PATH="/mnt/c/Users/rados/Projects/Bash/bash_scripts/LIB/"

. ${LIB_PATH}/logger.sh


function usage_generate() {
    echo -e "${BLUE}Usage: $0 [-h --help] [package_name]"
    echo -e "\t\t${BLUE}-h --help     -- Show this message"
    echo -e "\t\t${BLUE}-package_name -- Replace this with package name you want to install"
}


function update_packages() {
    log_debug "Updating packages..."
    sudo apt-get update |& tee -a "$control_file" &> /dev/null && log_success "Update has been completed."
    log_debug "Upgrading packages..."
    sudo apt-get upgrade -y |& tee -a "$control_file" &> /dev/null && log_success "Upgrade has been completed."
}


function check_install() {
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
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        usage_generate
        exit 1
    fi

    log_success "Control file ${UWHITE}${control_file}${NC} created."
    update_packages

    if [ $# -gt 0 ]; then
        check_install $@
    fi
}

main $@
