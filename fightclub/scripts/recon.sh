#!/usr/bin/env bash
#
# ABOUT
# These functions recon the system
# 
# PROVIDES
# recon_get_processes
# recon_get_services
# recon_get_listening

#######################################
# what
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function get_system_recon(){
    ps -aux  >> "${reconpath}"
    ss -tlpn >> "${reconpath}"
    systemctl --type=service >> "${reconpath}"
    
} 

#######################################
# what
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function recon_get_processes(){
    write_log_entry "${recon_processes_path}" "====== running processestree view\n"
    pstree -p >> "${recon_processes_path}"
    write_log_entry "${recon_processes_path}" "====== running processes\n "
    ps -aux >> "${recon_processes_path}"
    
}

#######################################
# what
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function recon_get_services(){

    write_log_entry "${recon_services_path}" "#====== services\n look for things like ftp, apache"
    systemctl --type=service >> "${recon_services_path}"
    # TODO analyse against a list
}

#######################################
# what
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function recon_get_listening(){
    write_log_entry "${recon_listening_path}" "#====== listening services; look here for anything that should not be running\n"
    echo""
    ss -tlpn | egrep --color=always -i '^|sshd|systemd-resolve|cupsd' | tee -a "${recon_listening_path}"
}

#######################################
# WIP
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function analyse_recondata(){
    #printf "todo\n"
    sleep 2
    
}

#######################################
# WIP
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function check_for_admins(){
    egrep -i 'sudo|adm' /etc/group | cut -d: -f4
    
}

#######################################
# WIP
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function check_recently_installed(){
    write_log_entry "${recon_install_path}" "====== recently installed apps\n# look for a known bad app and what installed around it"
    #use apt search <appname>
    grep -i 'install\s' /var/log/dpkg.log* >> "${recon_install_path}"
    zgrep -i 'install\s' /var/log/dpkg.log.*.gz >> "${recon_install_path}"
    
}