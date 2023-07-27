#!/usr/bin/env bash
#
# ABOUT
# These functions configure user accounts and passwords
# 
# PROVIDES
# disable_guest_account
# lock_root



#######################################
# what
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function disable_guest_account(){
    echo "allow-guest=false" >> /etc/lightdm/lightdm.conf
    echo "autologin-user=false" >> /etc/lightdm/lightdm.conf
    write_log_entry "${logpath}" "${0}"
}


#######################################
# lock root acount
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function lock_root(){
    passwd -l root
    write_log_entry "${logpath}" "${0}"
}
