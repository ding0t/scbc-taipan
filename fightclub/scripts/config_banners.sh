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
    tee -a "${banner_filename}" <EOF
This system is for official use only by authorised users
EOF
    tee -a "${banner_local_Filename}" <EOF
This system is for official use only by authorised users
EOF
write_log_entry "${logpath}" "${0}"
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
    gnome_banner_filename="/etc/dconf/db/gdm.d/01-banner-message"

    tee -a "${gdm_profile_filename}" <<EOF
[org/gnome/login-screen] 
banner-message-enable=true 
banner-message-text='This system is for official use only by authorised users.'
EOF   

    tee -a "${gnome_banner_filename}" <<EOF
user-db:user 
system-db:gdm 
file-db:/usr/share/gdm/greeter-dconf-defaults
EOF
dconf update
write_log_entry "${logpath}" "${0}"
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
    write_log_entry "${logpath}" "${0}"
}