#!/usr/bin/bash


LOG_PATH="/mnt/c/Users/rados/logs/"

current_date=$(date +"%F_%T.%3N")
script_name=$(basename $0)
control_file="${LOG_PATH}${script_name}_${current_date}.log"

RED="\e[0;31m"
GREEN="\e[0;32m"
BLUE="\e[0;34m"
LRED="\e[1;31m"
CYAN="\e[0;36m"
UWHITE="\e[4;37m"      
NC="\e[0m"


function log_info() {
    msg=$1
    current_time=$(date +"%F %T.%3N")
    echo -e "[${current_time}][ ${BLUE}INFO${NC}  ]: ${msg}" | tee -a "$control_file"
}


function log_success() {
    msg=$1
    current_time=$(date +"%F %T.%3N")
    echo -e "[${current_time}][${GREEN}SUCCESS${NC}]: ${msg}" | tee -a "$control_file"
}


function log_error() {
    msg=$1
    current_time=$(date +"%F %T.%3N")
    echo -e "[${current_time}][ ${RED}ERROR${NC} ]: ${msg}" | tee -a "$control_file"
}


function log_warning() {
    msg=$1
    current_time=$(date +"%F %T.%3N")
    echo -e "[${current_time}][${LRED}WARNING${NC}]: ${msg}" | tee -a "$control_file"
}


function log_debug() {
    msg=$1
    current_time=$(date +"%F %T.%3N")
    echo -e "[${current_time}][ ${CYAN}DEBUG${NC} ]: ${msg}" | tee -a "$control_file"
}

function log_input() {
    msg=$1
    current_time=$(date +"%F %T.%3N")
    echo -en "[${current_time}][ ${BLUE}INPUT${NC} ]: ${msg}" | tee -a "$control_file"
    read input
}
