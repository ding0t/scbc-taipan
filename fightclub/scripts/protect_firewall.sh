#!/usr/bin/env bash
#
# ABOUT
# These functions manage the firewall
# 
# PROVIDES


#######################################
# what
# Globals:
#   nil
# Arguments:
#   $1
# Outputs:
#   Nil
#######################################
function install_enable_firewall(){
    #create_edited_config_mark "${password_quality_filename}"
    apt install -y ufw gufw
    ufw enable
    ufw logging on
    ufw status
    #  ufw show listening
}