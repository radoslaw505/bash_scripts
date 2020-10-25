#!/usr/bin/bash


LIB_PATH="/mnt/c/Users/rados/Projects/Bash/bash_scripts/LIB/"
SCRIPT_PATH="/mnt/c/Users/rados/Projects/Bash/bash_scripts/"

. ${LIB_PATH}/logger.sh


function usage_generate {
    echo -e "${BLUE}Usage: $0 [-h --help]"
    echo -e "\t\t${BLUE}-h --help           -- Show this message"
    exit 0
}


function create_namespace {
    if [ $# -eq 0 ]; then
        log_error "Number of namespace's must be greater or equal 1."
        exit 1
    fi

    if [[ "$1" =~ ^-?[0-9]+$ && "$1" -ge 1 ]]; then
        for ((i=1, ii=1; i<="$1"; i++)); do
            ls "/var/run/netns/namespace${ii}" 2>> "/dev/null" 1>> "$control_file"

            while [ $? -eq 0 ]; do
                ((ii++))
                log_info "Namespace${ii} already exists."
                ls "/var/run/netns/namespace${ii}" 2>> "/dev/null" 1>> "$control_file"
            done

            log_debug "Creating namespace${ii}..."
            sudo ip netns add namespace${ii} 2>> "${SCRIPT_PATH}err.log" 1>> "$control_file"

            if [ $? -eq 0 ]; then
                log_success "Namespace${ii} has been created succesfully."
                ((ii++))
            fi
        done
    else
        log_error "You did not enter a number greater than 1."
        exit 2
    fi
}


function list_namespace {
    local all_done=0
    
    while (( !$all_done)); do
        options2=""
        for element in $(ip netns list; echo "exit"); do
            options2="${options2} ${element}"
        done

        PS3='[namespace]: '

        eval set $options2

        select option2 in "$@"; do
            if [[ "${option}" == "exit" ]]; then
                local all_done=1
                break
            fi

            if [[ "${option2}" == "${option2}" ]]; then
                action_namespace "${option2}"
                break
            fi
        done
    done
}


function clean_namespace {
    log_info "Starting to clear all namespaces."

    for element in $(ip netns list); do
        log_debug "Deleting an element: ${element}..."
        sudo ip netns del "${element}" 2>> "${SCRIPT_PATH}err.log" 1>> "$control_file"

        if [ $? -eq 0 ]; then
            log_success "Element: ${element} has been removed succesfully."
        else
            log_error "Error occured while deleting element: ${element}. Check: ${SCRIPT_PATH}err.log for more details."
            exit 1    
        fi
    done
}


function show_interfaces {
    log_info "List of interfaces:"
    ip -o link show | awk '{print $1,$9}' 2>> "${SCRIPT_PATH}err.log" | tee -a "$control_file"
}


function create_internal_ovs_port {
    if [ $# -ne 2 ]; then
        log_error "Network interface name or/and bridge has not been entered."
        exit 1
    fi

    log_debug "Creating interface ${1}..."
    sudo ovs-vsctl add-port "$2" "$1" -- set Interface "$1" type=internal 2>> "${SCRIPT_PATH}err.log" 1>> "$control_file"

    if [ $? -eq 0 ]; then
        log_success "Interface veth${1} with bridge ${2} has been created succesfully."
    else
        log_error "Error occured while creating interface. Check: ${SCRIPT_PATH}err.log for more details."
        exit 1
    fi
}


function create_ovs {
    if [ $# -ne 1 ]; then
        log_error "Ovs name has not been entered."
        exit 1
    fi

    log_debug "Creating ovs ${1}..."
    sudo ovs-vsctl add-br "$1" 2>> "${SCRIPT_PATH}err.log" 1>> "$control_file"

    if [ $? -eq 0 ]; then
        log_success "Ovs ${1} has been created succesfully."
    else
        log_error "Error occured while creating ovs. Check: ${SCRIPT_PATH}err.log for more details."
        exit 1
    fi
}


function action_namespace {
    local all_done=0

    while (( !$all_done )); do
        action_ns="\"Add network interface\" \"Set IP address\" \"Clear IP address\" \"Enter command\" \"Exit\""
        PS3="[${option2}]: "

        ns="${option2}"
        eval set "${action_ns}"

        select action in "$@"; do
            case "${action}" in
                "Add network interface")
                    show_interfaces
                    echo "-----------------------------------------------------"
                    log_input "Choose interface: " if_set
                    sudo ip link set "${if_set}" netns "${ns}" 2>> "${SCRIPT_PATH}err.log" 1>> "$control_file"
                    if [ $? -eq 0 ]; then
                        log_success "Interface ${if_set} has been added succesfully."
                    else
                        log_error "Error occured while adding interface. Check: ${SCRIPT_PATH}err.log for more details."
                        exit 1
                    fi
                    break
                    ;;
                "Set IP address")
                    sudo ip netns exec "${ns}" ip -o link show | awk '{print $2,$9}'
                    log_input "Choose interface: " if_set
                    log_input "Enter IP address (eg. 10.10.10.10/24): " ip_set

                    sudo ip netns exec "${ns}" ip a a "${ip_set}" dev "${if_set}" 2>> "${SCRIPT_PATH}err.log" 1>> "$control_file"
                    if [ $? -eq 0 ]; then
                        log_success "IP address ${ip_set} has been added succesfully."
                    else
                        log_error "Error occured while adding IP address. Check: ${SCRIPT_PATH}err.log for more details."
                        exit 1
                    fi

                    sudo ip netns exec "${ns}" ip l s dev "${if_set}" up 2>> "${SCRIPT_PATH}err.log" 1>> "$control_file"
                    if [ $? -eq 0 ]; then
                        log_success "IP address ${if_set} has been set-up succesfully."
                    else
                        log_error "Error occured while setting-up IP address. Check: ${SCRIPT_PATH}err.log for more details."
                        exit 1
                    fi
                    break
                    ;;
                "Clear IP address")
                    show_interfaces
                    echo "-----------------------------------------------------"
                    log_input "Choose interface: " if_set

                    sudo ip netns exec "${ns}" ip a f dev "${if_set}" 2>> "${SCRIPT_PATH}err.log" 1>> "$control_file"
                    if [ $? -eq 0 ]; then
                        log_success "IP address ${ip_set} has been cleared succesfully."
                    else
                        log_error "Error occured while clearing IP address. Check: ${SCRIPT_PATH}err.log for more details."
                        exit 1
                    fi

                    sudo ip netns exec "${ns}" ip l s dev "${if_set}" down 2>> "${SCRIPT_PATH}err.log" 1>> "$control_file"
                    if [ $? -eq 0 ]; then
                        log_success "IP address ${if_set} has been set-down succesfully."
                    else
                        log_error "Error occured while setting-down IP address. Check: ${SCRIPT_PATH}err.log for more details."
                        exit 1
                    fi
                    break
                    ;;
                "Enter command")
                    log_input "Enter command (eg. ping 10.10.10.10): " my_cmd
                    sudo ip netns exec "${ns}" "${my_cmd}" 2>> "${SCRIPT_PATH}err.log" 1>> "$control_file"
                    if [ $? -eq 0 ]; then
                        log_success "Command ${my_cmd} has been executed succesfully."
                    else
                        log_error "Error occured while executing command. Check: ${SCRIPT_PATH}err.log for more details."
                        exit 1
                    fi
                    break
                    ;;
                "Exit")
                    local all_done=1
                    break
                    ;;
            esac
        done
    done
}


function press_any_key {
    msg="Enter any key to continue..."
    current_time=$(date +"%F %T.%3N")
    echo -en "[${current_time}][ ${BLUE}INFO${NC}  ]: ${msg}" 2>&1 | tee -a "$control_file"
    sed -i 's/\[0;34m//' "$control_file"
    sed -i 's/\[0m//' "$control_file"
    read -n 1 -r -p " " | tee -a "$control_file"
}


function main_menu {
    options="\"Create network namespace\" \"Show namespace\" \"Clear all namespaces\" \"Add interface\" \"Create ovs-switch\" \"Enter command\" \"Exit\""

    eval set "${options}"

    local all_done=0
    while (( !$all_done )); do
        PS3="Choose option: "

        select option in "$@"; do
            case "${option}" in
                "Create network namespace")
                    log_input "Enter number of namespaces to create: " ns_number
                    create_namespace "${ns_number}"
                    break
                    ;;
                "Show namespace")
                    list_namespace
                    break
                    ;;
                "Clear all namespaces")
                    clean_namespace
                    ;;
                "Add interface")
                    log_info "Names of network interfaces:"
                    show_interfaces
                    echo "-----------------------------------------------------"
                    log_input "Enter network interface name: " ni_name
                    log_input "Choose bridge: " br_name
                    create_internal_ovs_port "veth${ni_name}" "${br_name}"
                    break
                    ;;
                "Create ovs-switch")
                    log_input "Enter new ovs name: " ovs_name
                    create_ovs "${ovs_name}"
                    sudo ip l s dev "${ovs_name}" up
                    break
                    ;;
                "Enter command")
                    log_input "CMD: " cmd
                    "${cmd}"
                    break
                    ;;
                "Exit")
                    local all_done=1
                    log_info "You are done with the namespace tool."
                    press_any_key
                    log_info "Done."
                    break
                    ;;
                "")
                    log_error "You entered wrong parameter: ${1}."
                    break
                    ;;
            esac
        done
    done
}


main_menu