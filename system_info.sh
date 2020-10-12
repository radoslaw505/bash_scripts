#!/usr/bin/bash

LIB_PATH="/mnt/c/Users/rados/Projects/Bash/bash_scripts/LIB/"

. ${LIB_PATH}/logger.sh


function usage_generate() {
    echo -e "${BLUE}Usage: $0 [-h --help][-s --system-info][-u --user-list][-g --group-list][-n --net-interfaces]"
    echo -e "\t${BLUE}-h --help           -- Show this message"
    echo -e "\t${BLUE}-s --system-info    -- Check system informations"
    echo -e "\t${BLUE}-u --user-info      -- Check current users"
    echo -e "\t${BLUE}-g --group-info     -- Check current groups"
    echo -e "\t${BLUE}-n --network-info   -- Check current net interfaces"
}


function options () {
    case $1 in
        "-h"|"--help" )
            usage_generate
            exit 1
            ;;
        "-s"|"--system-info" )
            system_info="true"
            ;;
        "-u"|"--user-info" )
            user_info="true"
            ;;
        "-g"|"--group-info" )
            group_info="true"
            ;;
        "-n"|"--network-info" )
            network_info="true"
            ;;
        "-d"|"--disk-info" )
            disk_info="true"
            ;;
        * )
            echo "No or incorrect option were chosen."
            usage_generate
            ;;
    esac
}


function system_info() {
    echo -e "${BLUE}Available arguments:"
    echo -e "\t${BLUE}kernel    - Return kernel version${NC}"
    echo -e "\t${BLUE}os        - Return os type${NC}"
    echo -e "\t${BLUE}distro    - Return distro version${NC}"
    echo -e "\t${BLUE}platform  - Return platform version${NC}"

    log_input "Enter argument: "
    case "$input" in
        kernel)
            log_success "Your Kernel version is: $(uname -r)"
            ;;
        os)
            log_success "Your Os type is: $(uname -s)"
            ;;
        distro)
            log_success "Your Distro version is: $(cat /proc/sys/kernel/version)"
            ;;
        platform)
            log_success "Your Platform version is: $(uname -m)"
            ;;
        *)
            log_warning "Incorrect parameter: $1."
            echo -e "${BLUE}Available arguments: kernel, os, distro, platform."
            exit 1
            ;;
    esac
}


function user_list() {
    echo -e "${BLUE}Available arguments:"
    echo -e "\t${BLUE}home    - Returns users with patch /home${NC}"
    echo -e "\t${BLUE}uid     - Return users with UID > 1000${NC}"
    echo -e "\t${BLUE}homeuid - Returns users with patch /home and UID > 1000${NC}"
    echo -e "\t${BLUE}bash    - Returns users with /bin/bash shell${NC}\n"

    log_input "Enter argument: "
    case "$input" in
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
            grep "/bin/bash" "/etc/passwd" | cut -d: -f1 | tee -a "$control_file"
            ;;
        *)
            log_warning "Given argument $1 is invalid."
            log_input "Do you want to list all users?[y/N]: "
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
                    echo -e "${BLUE}Available arguments: home, uid, homeuid, bash."
                    exit 1
                    ;;
            esac
            ;;
    esac
}


function group_list() {
    echo -e "${BLUE}Available arguments:"
    echo -e "\t${BLUE}cut    - Return groups using 'cut' command${NC}"
    echo -e "\t${BLUE}awk    - Return groups using 'awk' command${NC}"

    log_input "Enter argument: "
    case "$input" in
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
            echo -e "${BLUE}Available arguments: cut, awk."
            exit 1
            ;;
    esac
}


function net_interfaces() {
    echo -e "${BLUE}Available arguments:"
    echo -e "\t${BLUE}inet      - Return network interfaces${NC}"
    echo -e "\t${BLUE}stat      - Return names ofnetwork interfaces with status UP/DOWN${NC}"
    echo -e "\t${BLUE}iname     - Return names of network interfaces:${NC}"
    echo -e "\t${BLUE}kerneli   - Return list of network interfaces seen in kernel table${NC}"
    echo -e "\t${BLUE}iaddress  - Return list of interfaces witch IPv4 and IPv6${NC}"
    echo -e "\t${BLUE}ifls      - Return list of network devices and their names (interfaces)${NC}"

    log_input "Enter argument: "
    case "$input" in
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
            echo -e "${BLUE}Available arguments: inet, stat, iname, kerneli, iaddress, ifls"
            exit 1
            ;;
        
    esac
}


function disk_info() {
    echo -e "${BLUE}Available arguments:"
    echo -e "\t${BLUE}space     - Return space available on all currently mounted file systems${NC}"
    echo -e "\t${BLUE}all       - Return space available on all currently mounted file systems include pseudo, duplicate, inaccessible file systems${NC}"
    echo -e "\t${BLUE}total     - Return all entries insignificant to available space, and produce a grand total${NC}"

    log_input "Enter argument: "
    case "$input" in
        "space")
            log_success "Space available on all currently mounted file systems:"
            df -h | tee -a "$control_file"
            ;;
        "all")
            log_success "Space available on all currently mounted file systems include pseudo, duplicate, inaccessible file systems:"
            df -ha | tee -a "$control_file"
            ;;
        "total")
            log_success "Space available on all currently mounted file systems, and total space:"
            df -h --"${input}" | tee -a "$control_file"
            ;;
        *)
            log_warning "Incorrect parameter: $1."
            echo -e "${BLUE}Available arguments: space, all, total."
            exit 1
            ;;
    esac
}


function main() {
    options "$1"

    if [ "$system_info" = "true" ]; then
        system_info && exit 0
    fi
    if [ "$user_info" = "true" ]; then
        user_list && exit 0
    fi
    if [ "$group_info" = "true" ]; then
        group_list && exit 0
    fi
    if [ "$network_info" = "true" ]; then
        net_interfaces && exit 0
    fi
    if [ "$disk_info" = "true" ]; then
        disk_info && exit 0
    fi
}


main "$1"
