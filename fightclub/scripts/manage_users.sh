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
		    (deluser $i --remove-all-files >> "${logpath}") &  #starts deleting in background
	    fi
done
}


#######################################
#  
# Globals:
#   nil
# Arguments:
#   expect the filename as first function argument
# Outputs:
#   sets global array
#######################################
function get_current_standard_users_list(){
    A_CURRENT_STD_USERS=("$(cat /etc/passwd | cut -d: -f 1,3,6 | grep -e "[5-9][0-9][0-9]" -e "[0-9][0-9][0-9][0-9]" | grep "/home" | cut -d: -f1)")
    # create associative array using map username:key
    declare -A A_MAP_CURRENT_STD_USERS
    for key in "${!A_CURRENT_STD_USERS[@]}"; do A_MAP_CURRENT_STD_USERS[${A_CURRENT_STD_USERS[$key]}="${key}"]; done
    #for i in $(cat /etc/passwd | cut -d: -f 1,3,6 | grep -e "[5-9][0-9][0-9]" -e "[0-9][0-9][0-9][0-9]" | grep "/home" | cut -d: -f1) ; do
	    # if user not in the README
       # if [[ $( grep -ic -e $i $(pwd)/README ) -eq 0 ]]; then	
		#    (deluser $i --remove-all-files >> "${logpath}") &  #starts deleting in background
	    #fi
}

#######################################
# Creates users from a csv, the csv must be newline terminated
# Globals:
#   nil
# Arguments:
#   $1 expect the filename as first function argument
# Outputs:
#   Nil
#######################################
function audit_users(){
    # get a list of current users on the system
    get_current_standard_users_list
    # UID_MAX, UID_MIN
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
        $ process the columns
        A_USERNAME+=("$COL1")
        A_ISADMIN+=("$COL2")
        A_PASSWORD+=("$COL3")
    done <"${users_csv_file}"

    # iterate through existing users to look for anomalies
    declare -A A_MAP_USERNAMES
    for key in "${!A_USERNAME[@]}"; do 
        A_MAP_USERNAMES[${A_USERNAME[$key]}="${key}"]
    done
    for j in "${A_CURRENT_STD_USERS[@]}"; do
        # if username not in authorised list
        if ! [[ -n "${A_MAP_USERNAMES["${j}"]}" ]]; then
            printf "WARNING! Found unauthorised user: ${j}\n"
        fi
    done

    # -g adds a a user to the named group and creates the group if it does not exist
    # -G appends the user to existing groups
    for i in "${!A_USERNAME[@]}"; do
        #! loops over index vs values
        # current logged in user
        if [[ "${A_USERNAME[$i]}"  =~ "${SUDO_USER:-$USER}" ]]; then
            # this is the user executing the script!
            printf "User '${SUDO_USER:-$USER}' is likely you!.\n"
            continue
        fi
        # do they exist, if not make them
        if ! [[ $(grep -i "${A_USERNAME[$i]}" /etc/passwd) ]]; then
            #add_user "${A_USERNAME[$i]}" "${A_PASSWORD[$i]}"
            printf "Add user: ${A_USERNAME[$i]}\n"
        fi
        # should they be admin
        if [[ "${A_ISADMIN[$i]}"  =~ "y" ]]; then
            # if yes, add them
            #add_admin "${A_USERNAME[$i]}"
            printf "Add admin for user: ${A_USERNAME[$i]}"
        # if no remove them
        else 
            remove_admin "${A_USERNAME[$i]}"
            printf "Remove admin for user: ${A_USERNAME[$i]}"
        fi
    done
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

#######################################
#  Launched the users gui
# Globals:
#   A_USERNAME, A_PASSWORD, A_ISADMIN
# Arguments:
#   $1 username
#   
# Outputs:
#   Nil
#######################################
function add_user(){
    # user paremeter substitution to call script user vs root
    #runuser -l "${SUDO_USER:-$USER}" -c "gnome-control-center  user-accounts &"
    #groupadd -f "${A_GROUP[$i]}"
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
}