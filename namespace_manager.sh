#!/usr/bin/bash


LIB_PATH="/mnt/c/Users/rados/Projects/Bash/bash_scripts/LIB/"

. ${LIB_PATH}/logger.sh


function usage_generate {
    echo -e "${BLUE}Usage: $0 [-h --help]"
    echo -e "\t\t${BLUE}-h --help           -- Show this message"
    exit 0
}


function main_menu {
    options="\"Create network namespace\" \"Show namespace\" \"Clear all namespaces\" \"Add interface\" \"Create ovs-switch\" \"Enter command\" \"Exit\""

    eval set $options

    local all_done=0
    while (( !$all_done )); do
        PS3="Choose option: "

        select option in $0; do
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
                create_interval_osv_port "veth${ni_name}" "${br_name}"
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
                log_error "You entered wrong parameter: ${0}. "
                break
                ;;    
    done
}


function create_namespace {

}


function list_namespace {
    
}


function clean_namespace {
    
}


function show_interfaces {
    
}


function create_interval_osv_port {
    
}


function create_ovs {
    
}


function press_any_key {
    
}


main_menu