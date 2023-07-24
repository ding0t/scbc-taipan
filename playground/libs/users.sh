#!/bin/bash
#
# ABOUT
# Author: ding0t
# this script provides functions to set up users and group
#
#TODO
# output a list of users expected, and privs
# add users that do not match list
# make users with poor passwords
# make users in wrong groups
#######################################

#######################################
# CAdds a user as admin in Ubuntu
# Globals:
#   nil
# Arguments:
#   expect a username
# Outputs:
#   Nil
#######################################
function add_admin(){
    usermod -aG adm,cdrom,sudo,dip,plugdev,lpadmin,lxd,sambashare ${1}
}

#######################################
# Creates users from a csv
# Globals:
#   nil
# Arguments:
#   expect the filename as first function argument
# Outputs:
#   Nil
#######################################
function add_users(){
    # 
    users_csv_file=${1}
    echo "adding users from csv file: ${users_csv_file}"
    # put each column into an array
    declare -a A_SURNAME
    declare -a A_NAME
    declare -a A_USERNAME
    declare -a A_GROUP
    declare -a A_PASSWORD
    # read each line into the array, note order of csv
    while IFS=, read -r COL1 COL2 COL3 COL4 COL5 TRASH; do
        A_SURNAME+=("$COL1")
        A_NAME+=("$COL2")
        A_USERNAME+=("$COL3")
        A_GROUP+=("$COL4")
        A_PASSWORD+=("$COL5")
    done <"${users_csv_file}"
    # now add each user by iterating over the arrays
    # -g addsa a user to the named group and creates the group if it does not exist
    for i in "${!A_USERNAME[@]}"; do
        if [[ ! "${A_USERNAME[$i]}"  =~ "USERNAME" ]]; then
            # add group and silently fail if exists
            groupadd -f "${A_GROUP[$i]}"
            # add user
            useradd -g "${A_GROUP[$i]}" \
            -d "/home/${A_USERNAME[$i]}" \
            -s /bin/bash \
            -p "$(echo "${A_PASSWORD[$i]}" | openssl passwd -1 -stdin)" \
            "${A_USERNAME[$i]}"
            # make admin user if sudo
            if [[ "${A_GROUP[$i]}" == "sudo" ]]; then
                add_admin "${A_USERNAME[$i]}"
            fi
        fi
    done
}

