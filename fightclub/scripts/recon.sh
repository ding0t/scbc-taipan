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
    write_log_entry "${logpath}" "${0}"
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
    write_log_entry "${reconpath}" "====== running processes; "
    ptree -p >> "${reconpath}"
    write_log_entry "${reconpath}" "====== running processes tree view; "
    ps -aux >> "${reconpath}"
    write_log_entry "${logpath}" "${0}"
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
    write_log_entry "${reconpath}" "====== services; "
    systemctl --type=service >> "${reconpath}"
    write_log_entry "${logpath}" "${0}"
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
    write_log_entry "${reconpath}" "====== listening services; look here for anything that should not be running"
    ss -tlpn >> "${reconpath}"
    write_log_entry "${logpath}" "${0}"
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
    write_log_entry "${logpath}" "${0}"
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
    grep -i sudo /etc/group
    grep -i adm /etc/group
    write_log_entry "${logpath}" "${0}"
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
function check_installed(){
    #use apt search <appname>
    apt list --installed 
    grep -i 'install\s' /var/log/dpkg.log*
    zgrep -i 'install\s' /var/log/dpkg.log.*.gz
    write_log_entry "${logpath}" "${0}"
}