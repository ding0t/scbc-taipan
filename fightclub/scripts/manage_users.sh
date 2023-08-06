#!/usr/bin/env bash
#
# ABOUT
# These functions configure users
# 
# PROVIDES
# apt_purge_tools
# apt_purge_servcies


#######################################
#  Launched the users gui
# Globals:
#   nil
# Arguments:
#   expect the filename as first function argument
# Outputs:
#   Nil
#######################################
function launch_settings_users_gui(){
    # user paremeter substitution to call script user vs root
    #runuser -l "${SUDO_USER:-$USER}" -c "gnome-control-center  user-accounts &"
    gnome-control-center  user-accounts &
}


#######################################
#  
# Globals:
#   nil
# Arguments:
#   expect the filename as first function argument
# Outputs:
#   Nil
#######################################
function remove_users_not_in_list(){
    
    for i in $(cat /etc/passwd | cut -d: -f 1,3,6 | grep -e "[5-9][0-9][0-9]" -e "[0-9][0-9][0-9][0-9]" | grep "/home" | cut -d: -f1) ; do
	    # if user not in the README
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
    declare -a A_USERNAME
    declare -a A_ISADMIN
    declare -a A_PASSWORD
    # read each line into the approprate array, note order of csv matters
    while IFS=| read -r COL1 COL2 COL3 TRASH; do
        # ignore comment lines
        [[ "$COL1" =~ ^#.*$ ]] && continue
        $ process th ecolumns
        A_USERNAME+=("$COL1")
        A_ISADMIN+=("$COL2")
        A_PASSWORD+=("$COL3")
    done <"${users_csv_file}"
    # now add each user by iterating over the arrays
    # -g adds a a user to the named group and creates the group if it does not exist
    # -G appends the user to existing groups
    for i in "${!A_USERNAME[@]}"; do
        #! loops over index vs values
        if [[ ! "${A_USERNAME[$i]}"  =~ "USERNAME" ]]; then
            # add group and silently fail if exists
            groupadd -f "${A_GROUP[$i]}"
            # add user to supplemantary groups with -G
            useradd -G "${A_GROUP[$i]}" \
            -d "/home/${A_USERNAME[$i]}" \
            -s /bin/bash \
            -p "$(echo "${A_PASSWORD[$i]}" | openssl passwd -1 -stdin)" \
            "${A_USERNAME[$i]}"
            # make admin user if sudo
            if [[ "${A_GROUP[$i]}" == "sudo" ]]; then
                add_admin "${A_USERNAME[$i]}"
            fi
            # make the home dir
            mkdir "/home/${A_USERNAME[$i]}"
            chown  "${A_USERNAME[$i]}":"${A_USERNAME[$i]}" "/home/${A_USERNAME[$i]}"
        fi
    done
}

#######################################
# Adds an existing user as admin in Ubuntu
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
# Adds an existing user as admin in Ubuntu
# Globals:
#   nil
# Arguments:
#   $1 expect a username
# Outputs:
#   Nil
#######################################
function remove_admin(){
    A_ADMIN_GROUPS=(adm sudo lpadmin)
    for groupname in "${A_ADMIN_GROUPS[@]}"; do
        gpasswd -d "${1}"  "${groupname}"
    done
}
