#!/usr/bin/env bash
#
# ABOUT
# These functions configure login banners apart from ssh which is in ssh_config.sh
# 
# PROVIDES
# set_motd_terminal
# set_gnome_login_banner
# set_banner_permissions


#######################################
# Set terminal banners
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
# Ref
# https://secscan.acron.pl/ubuntu1604/1/7/2
# https://help.gnome.org/admin/system-admin-guide/stable/login-banner.html.en
#######################################
function set_motd_terminal(){
    # note /etc/issue.net is set in ssh_config
    banner_warn_filename="/etc/login.warn"
    banner_local_Filename="/etc/issue"
    banner_motd_filename="/etc/motd"

    install -D -m 644  "$(dirname "${0}")/rsc/banner.txt" "${banner_warn_filename}" 
    install -D -m 644  "$(dirname "${0}")/rsc/banner.txt" "${banner_local_Filename}"
    install -D -m 644  "$(dirname "${0}")/rsc/banner.txt" "${banner_motd_filename}"

}


#######################################
# Set gui banner
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
# Ref
# https://secscan.acron.pl/ubuntu1604/1/7/2
# https://help.gnome.org/admin/system-admin-guide/stable/login-banner.html.en
#######################################
function set_gnome_login_banner(){
    gdm_profile_filename="/etc/dconf/profile/gdm"
    gdm_keyfile_filename="/etc/dconf/db/gdm.d/01-banner-message"

    install -D -m 644 "$(dirname "${0}")/rsc/gdm" "${gdm_profile_filename}" 
    install -D -m 644 "$(dirname "${0}")/rsc/01-banner-message" "${gdm_keyfile_filename}" 
    # 
    dconf update
}

#######################################
# Set banner permissions
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
# Ref
# https://secscan.acron.pl/ubuntu1604/1/7/2
#######################################
function set_banner_permissions(){
    chown root:root /etc/issue
    chmod 644 /etc/issue 
    chown root:root /etc/issue.net 
    chmod 644 /etc/issue.net
    chown root:root /etc/motd 
    chmod 644 /etc/motd
    
}