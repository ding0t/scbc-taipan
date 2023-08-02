#!/usr/bin/env bash
#
# ABOUT
# These functions remove snap 
# 
# PROVIDES
# apt_purge_tools
# apt_purge_servcies
# snap_remove

#######################################
# Update default browser]
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function set_default_browser(){
    update-alternatives --config x-www-browser
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
function enable_security_updates(){
    apt_sources_file="/etc/apt/sources.list"
    create_backup_of_file "${passwd_logins_config_file}"
    sed -i '/security.ubuntu/s/^#//g' "${passwd_logins_config_file}"
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
function launch_updates_config_gui(){
    software-properties-gtk &
}