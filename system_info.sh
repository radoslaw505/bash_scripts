#!/usr/bin/bash


. ./lib/logger.sh


function mysystem_info() {
    if [ $# -eq 0 ]; then
        log_warning "No argument were given."
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


function user_list() {
    if [ $# -lt 1 ]; then
        log_warning "No argument were given."
        echo -e "${BLUE}$0 <arg>"
        echo -e "${BLUE}Available arguments:"
        echo -e "\t${BLUE}- home    -- Returns users with patch /home"
        echo -e "\t${BLUE}- uid     -- Return users with UID > 1000"
        echo -e "\t${BLUE}- homeuid -- Returns users with patch /home and UID > 1000"
        echo -e "\t${BLUE}- bash    -- Returns users with /bin/bash shell"
        exit 1
    fi

    case "$1" in
        home)
            log_success "Users list:"
            awk -F: '/\/home/ {printf "%s:%s\n",$1,$3}' /etc/passwd | tee -a "$control_file"
            ;;
        uid)
            log_success "Users list:"
            awk -F: '($3 >= 1000) {printf "%s:%s\n",$1,$3}' /etc/passwd | tee -a "$control_file"
            ;;
        homeuid)
            log_success "Users list:"
            awk -F: '/\/home/ && ($3 >= 1000) {printf "%s:%s\n",$1,$3}' /etc/passwd | tee -a "$control_file"
            ;;
        bash)
            log_success "Users list:"
            cat "/etc/passwd" | grep "/bin/bash" | cut -d: -f1 | tee -a "$control_file"
            ;;
        *)
            log_warning "Given argument $1 is invalid."
            log_input "Do you want to list all users?"
            case "$input" in
                [yY])
                    log_success "Users list:"
                    cut -d: -f1 /etc/passwd | tee -a "$control_file"
                    ;;
                [nN])
                    log_info "You enter: ${input}. Ending script"
                    ;;
                *)
                    log_warning "Incorrect input: ${input}."
                    exit 1
                    ;;
            esac
            ;;
    esac
}


function group_list() {
    case "$1" in
        cut)
            log_success "Group list:"
            cut -d: -f1 /etc/group | tee -a "$control_file"
            ;;
        awk)
            log_success "Group list:"
            awk -F: '{print $1}' /etc/group | tee -a "$control_file"
            ;;
        *)
            log_warning "Incorrect parameter: $1."
            echo -e "${BLUE}$0 <arg>"
            echo -e "${BLUE}Available arguments: cut, awk"
            exit 1
            ;;
    esac
}


function net_interfaces() {
    case "$1" in
        inet)
            log_success "Network interfaces:"
            ip link show | tee -a "$control_file"
            ;;
        stat)
            log_success "Names of network interfaces with status UP/DOWN:"
            ip -o link show | awk '{print $2,$9}' | tee -a "$control_file"
            ;;
        iname)
            log_success "Names of network interfaces:"
            ip -o link show | awk -F: '{print $2}' | tee -a "$control_file"
            ;;
        kerneli)
            log_success "List of network interfaces seen in kernel table:"
            netstat -i | tee -a "$control_file"
            ;;
        iaddress)
            log_success "List of interfaces witch IPv4 and IPv6:"
            for i in $(ip ntable | grep dev | sort -u | awk '{print $2}'); do
                echo "Network interface: $i" | tee -a "$control_file"
                ifconfig "$i" | grep inet | sed -e 's/\<inet\>/IPv4:/g' | sed -e 's/\<inet6\>/IPv6:/g' | awk 'BEGIN{OFS="\t"}{print $1,$2}' | tee -a "$control_file"
            done
            ;;
        ifls)
            log_success "List of network devices and their names (interfaces):"
            ls /sys/class/net | tee -a "$control_file"
            ;;
        *)
            log_warning "Incorrect parameter: $1."
            echo -e "${BLUE}$0 <arg>"
            echo -e "${BLUE}Available arguments: inet, stat, iname, kerneli, iaddress, ifls"
            exit 1
            ;;
        
    esac
}


function main() {
    # mysystem_info $1
    # user_list $1
    # group_list $1
    net_interfaces $1
}


main $1
