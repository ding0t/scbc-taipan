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
    echo "none     /dev/shm     tmpfs     ro,noexec,nosuid,nodev     0     0" >> /etc/fstab
    mount -o remount /dev/shm
    
}