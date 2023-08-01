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
# Remove installed snaps
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function snap_remove_all_installed(){
    snap_installed_a=($(snap list | awk 'NR > 1 {print $1}' | sort -r ))
    for snap_package in "${snap_installed_a}"; do
        snap remove --purge "${snap_package} -y"
    done
}


#######################################
# Completely purge snap
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function remove_snapd(){
    snap_mount=($(df -h | grep snap | awk '{print $6}' ))
    umount snap_mount
    apt remove --autoremove snapd -y
}


#######################################
# Prevent snap reinstall
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function snap_prevent_reinstall(){
    config_filename="/etc/apt/preferences.d/nosnap.pref"
    tee -a "${config_filename}" <<EOF
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF
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
function snap_remove_named_tools(){
	A_SNAP_TOOLS=(nmap 
	john-the-ripper)
    for i in "${A_SNAP_TOOLS[@]}"; do
        snap remove "${i}"
    done
	write_log_entry "${logpath}" "${0}"
}
