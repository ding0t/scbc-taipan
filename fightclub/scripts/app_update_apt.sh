#!/usr/bin/env bash
#
# ABOUT
# These functions update applications by apt
# 
# PROVIDES
# apt_purge_tools
# apt_purge_servcies
# snap_remove


#######################################
# Latest firefox
# WORKING
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
# Ref: https://www.debugpoint.com/remove-snap-ubuntu/
#######################################
function apt_manage_firefox(){
    add-apt-repository ppa:mozillateam/ppa
    apt update
    apt install -t 'o=LP-PPA-mozillateam' firefox -y
} 

#######################################
# latest libreoffice
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
# Ref: https://www.debugpoint.com/remove-snap-ubuntu/
#######################################
function apt_manage_firefox(){
    add-apt-repository ppa:libreoffice/ppa
    apt update
    apt upgrade -y
} 