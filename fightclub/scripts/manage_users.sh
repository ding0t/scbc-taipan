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
    (sudo -u ${SUDO_USER:-$USER} gnome-control-center  user-accounts) &
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
#   sets global array A_CURRENT_STD_USERS
#######################################
function get_current_standard_users_list(){
    A_CURRENT_STD_USERS=( $(cat "/etc/passwd" | cut -d: -f 1,3,6 | grep -e "[5-9][0-9][0-9]" -e "[0-9][0-9][0-9][0-9]" | grep "/home" | cut -d: -f1) )
    # create associative array using map username:key
    #declare -A A_MAP_CURRENT_STD_USERS
    #for key in "${!A_CURRENT_STD_USERS[@]}"; do A_MAP_CURRENT_STD_USERS[${A_CURRENT_STD_USERS[$key]}="${key}"]; done
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
    local i
    local j
    local make_changes=$2

    if [[ $make_changes == 'true' ]]; then 
        echo "This run will make changes!"
        write_log_entry "${logpath}" " INFO: making changes to users as follows..."
    fi
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
    while IFS=, read -r COL1 COL2 COL3 TRASH; do
        # ignore comment lines 
        [[ "$COL1" =~ ^#.*$ ]] && continue
        # process the columns
        A_USERNAME+=("$COL1")
        A_ISADMIN+=("$COL2")
        A_PASSWORD+=("$COL3")
    done <"${users_csv_file}"
    #echo "File: ${users_csv_file}"
    #echo "List of Users: ${A_USERNAME[@]}"

    # iterate through existing users to look for anomalies
    declare -A A_MAP_USERNAMES
    for i in ${A_USERNAME[@]}; do 
        # key = username; value = index
        A_MAP_USERNAMES["${i}"]=1
    done
    #echo "Current users: ${A_CURRENT_STD_USERS[@]}"
    #echo "List of Users MAP: ${!A_MAP_USERNAMES[@]}"
    
    # test current users to look for unauthorised users
    for j in "${A_CURRENT_STD_USERS[@]}"; do
        # if username not in authorised list
        #user_exists=False
        #for i in "${A_USERNAME[@]}"; do [[ "${j}" == "${i}" ]]  && $user_exists=True; done
        #If username exists as a key in the associative array list of users from file
        if ! [[ -n ${A_MAP_USERNAMES[${j}]} ]]; then
            echo "WARNING! Found unauthorised user: ${j}"
            
            if [[ $make_changes == 'true' ]]; then 
                # remove user
                # confirm?
                write_log_entry "${logpath}" "Removing unauthorised user and their home directory: ${j}"
                deluser "${j}"  --remove-home >> "${logpath}"
            else
                write_log_entry "${user_audit_path}" "WARNING! Found unauthorised user: ${j}"
            fi
        fi
    done

    ## itereate over the authorised users file
    for i in "${!A_USERNAME[@]}"; do
        #! loops over index vs values
        # current logged in user
        if [[ "${A_USERNAME[$i]}"  =~ "${SUDO_USER:-$USER}" ]]; then
            # this is the user executing the script!
            echo "User '${SUDO_USER:-$USER}' is likely you! Will not change anything."
            write_log_entry "${user_audit_path}" "User '${SUDO_USER:-$USER}' is likely you! Will not change anything."
            continue
        fi
        # do they exist, if not make them
        if ! [[ $(grep -i "${A_USERNAME[$i]}" /etc/passwd) ]]; then
            #
            echo "Authorised user does not exist, add user: ${A_USERNAME[$i]}"
             
            if [[ $make_changes == 'true' ]]; then 
                # 
                write_log_entry "${logpath}" "Adding authorised user: ${A_USERNAME[$i]}"
                add_user "${A_USERNAME[$i]}" "${A_PASSWORD[$i]}"
            else
                write_log_entry "${user_audit_path}" echo "Authorised user does not exist, add user: ${A_USERNAME[$i]}"
            fi
        fi
        # should they be admin
        # sorry nested ifs follow
        if [[ "${A_ISADMIN[$i]}"  =~ "y" ]]; then
            # if yes, add them
            #"
            echo "Add admin for user: ${A_USERNAME[$i]}"
            
            if [[ $make_changes == 'true' ]]; then 
                # 
                write_log_entry "${logpath}" "Adding admin privilige to user: ${A_USERNAME[$i]}"
                add_admin "${A_USERNAME[$i]}"
            else
                write_log_entry "${user_audit_path}" "Add admin for user: ${A_USERNAME[$i]}"
            fi
        # if no test if admin and remove them
        else 
            # testing, but not needed if user is not admin anyway
            if [[ $(id -nG ${A_USERNAME[$i]} | egrep -qiw "sudo|adm") ]]; then
                 echo "WARNING! Remove admin for standard user: ${A_USERNAME[$i]}"
                if [[ $make_changes == 'true' ]]; then 
                    # 
                    write_log_entry "${logpath}" "Removing admin privilige frm user: ${A_USERNAME[$i]}"
                    remove_admin "${A_USERNAME[$i]}"
                else
                    write_log_entry "${user_audit_path}" "WARNING! Remove admin for standard user: ${A_USERNAME[$i]}"
                fi
            fi

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
#   $2 password
# Outputs:
#   Nil
#######################################
function add_user(){
    # user paremeter substitution to call script user vs root
    #runuser -l "${SUDO_USER:-$USER}" -c "gnome-control-center  user-accounts &"
    #groupadd -f "${A_GROUP[$i]}"
    # add user to supplemantary groups with -G
    # -g adds a a user to the named group and creates the group if it does not exist
    # -G appends the user to existing groups -G "${A_GROUP[$i]}" 
    useradd  -d "/home/${A_USERNAME[$i]}" \
    -s /bin/bash \
    -p "$(echo "${A_PASSWORD[$i]}" | openssl passwd -1 -stdin)" \
    "${A_USERNAME[$i]}"
    # make the home dir
    mkdir "/home/${A_USERNAME[$i]}"
    chown  "${A_USERNAME[$i]}":"${A_USERNAME[$i]}" "/home/${A_USERNAME[$i]}"
}