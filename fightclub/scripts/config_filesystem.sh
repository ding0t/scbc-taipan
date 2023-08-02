#!/usr/bin/env bash
#
# ABOUT
# These functions configure the filesystem
# 
# PROVIDES


#######################################
# disables the /dev/shm temporary file system; not sure of effects in challenge or what applications need it
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function disable_shm(){
    # should test if line exists, add if does not
    fstab_filename="/etc/fstab"
    create_backup_of_file "${fstab_filename}"
    echo "none     /dev/shm     tmpfs     ro,noexec,nosuid,nodev     0     0" >> "${fstab_filename}"
    create_edited_config_mark "${fstab_filename}"
    mount -o remount /dev/shm
    
}