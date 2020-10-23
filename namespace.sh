#!/usr/bin/bash


LIB_PATH="/mnt/c/Users/rados/Projects/Bash/bash_scripts/LIB/"

. ${LIB_PATH}/logger.sh


function usage_generate() {
    echo -e "${BLUE}Usage: $0 [-h --help][-s --system-info][-u --user-list][-g --group-list][-n --net-interfaces]"
    echo -e "\t\t${BLUE}-h --help           -- Show this message"
    echo -e "\t\t${BLUE}-s --system-info    -- Check system informations"
    echo -e "\t\t${BLUE}-u --user-info      -- Check current users"
    echo -e "\t\t${BLUE}-g --group-info     -- Check current groups"
    echo -e "\t\t${BLUE}-n --network-info   -- Check current net interfaces"
    exit 0
}

log_info "test"
log_error "test"
log_warning "test"
log_debug "test"
log_success "test"
log_input "test"