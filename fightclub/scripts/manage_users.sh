#!/usr/bin/env bash
#
# ABOUT
# These functions remove applications
# 
# PROVIDES
# apt_purge_tools
# apt_purge_servcies


function remove_users(){
    for i in $(cat /etc/passwd | cut -d: -f 1,3,6 | grep -e "[5-9][0-9][0-9]" -e "[0-9][0-9][0-9][0-9]" | grep "/home" | cut -d: -f1) ; do
	    if [[ $( grep -ic -e $i $(pwd)/README ) -eq 0 ]]; then	
		    (deluser $i --remove-all-files >> RemovingUsers.txt 2>&1) &  #starts deleting in background
	    fi
done
}

#######################################
# Creates users from a csv, the csv must be newline terminated
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
    #echo "adding users from csv file: ${users_csv_file}"
    # put each column into an indexed array
    declare -a A_SURNAME
    declare -a A_NAME
    declare -a A_USERNAME
    declare -a A_GROUP
    declare -a A_PASSWORD
    # read each line into the approprate array, note order of csv matters
    while IFS=, read -r COL1 COL2 COL3 COL4 COL5 TRASH; do
        A_SURNAME+=("$COL1")
        A_NAME+=("$COL2")
        A_USERNAME+=("$COL3")
        A_GROUP+=("$COL4")
        A_PASSWORD+=("$COL5")
    done <"${users_csv_file}"
    # now add each user by iterating over the arrays
    # -g adds a a user to the named group and creates the group if it does not exist
    # -G appends the user to existing groups
    for i in "${!A_USERNAME[@]}"; do
        #! loops over index vs values
        if [[ ! "${A_USERNAME[$i]}"  =~ "USERNAME" ]]; then
            # add group and silently fail if exists
            groupadd -f "${A_GROUP[$i]}"
            # add user
            useradd -G "${A_GROUP[$i]}" \
            -d "/home/${A_USERNAME[$i]}" \
            -s /bin/bash \
            -p "$(echo "${A_PASSWORD[$i]}" | openssl passwd -1 -stdin)" \
            "${A_USERNAME[$i]}"
            # make admin user if sudo
            if [[ "${A_GROUP[$i]}" == "sudo" ]]; then
                add_admin "${A_USERNAME[$i]}"
            fi
            mkdir "/home/${A_USERNAME[$i]}"
            chown  "${A_USERNAME[$i]}":"${A_USERNAME[$i]}" "/home/${A_USERNAME[$i]}"
        fi
    done
}