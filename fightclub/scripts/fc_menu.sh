#!/usr/bin/env bash
#
# ABOUT
# These functions setup the main selection menu
#
# ADDING AN OPTION
# 1. add a new option variable and assign a dsiplay name
# 2. add the option to the option array; this is the display order
# 3. add a case statemeent and execution instructions to the function "execute_option"
# 
# PROVIDES
# print_logo
# print_menu
# get_user_selected_option
# execute_option



#######################################
# builds the options array
# Globals:
#   num_options
#   a_option_runs
# Arguments:
#   
# Outputs:
#   Sets up the option menu
#######################################
function build_options_menu(){
    # 1
    # define menu options for options array
    # This text will be used in the case statement, keep short
    # show state

    opt_sh_installed="RECON: find recently installed apps"
    opt_sh_listen="RECON: listening connections"
    opt_sh_svcs="RECON: active services"
    opt_sh_process="RECON: running processes"
    # users
    opt_launch_users_gui="USERS: Launch user setup gui"
    opt_audit_users="USERS: Audit users against config file"
    # applications
    opt_update="APPS: Update system and applications"
    opt_purge_tools="APPS: Purge hacker tools"
    opt_purge_services="APPS: remove likely uneeded services"
    opt_rm_snap="APPS: Remove snap package manager"
    opt_launch_updates_config_gui="APPS: launch 'Software & Updates' GUI"
    # configure settings
    opt_set_ssh="CONFIG: Configure SSH"
    opt_set_banners="CONFIG: set login banners"
    opt_set_account_policies="CONFIG: set password and account policies"
    opt_set_kernel="CONFIG: set kernel defaults"
    opt_set_audit="CONFIG: set audit policies"
    opt_set_shm="CONFIG: Disable /dev/shm"
    # forensics
    opt_find_media_files="FORENSICS: Find media files"
    opt_delete_media_files="FORENSICS: DELETE media files"
    # protect
    opt_protect_install_av="PROTECT: Install clamAV and update signatures"
    opt_protect_run_av="PROTECT: Run clamav"
    opt_protect_install_firewall="PROTECT: Install Firewall and enable"
    opt_protect_conf_firewall="PROTECT: Configure Firewall"
    # script operations
    opt_sh_tips="FightClub: show tips"
    opt_quit="FightClub: Quit"
    opt_show_functions="FightClub: Show available functions"
    opt_clean_menu="FightClub: Redisplay  menu"

    # 2
    # order of array will set order of options
    # Place them in reccomended order of execution
    A_OPTIONS=("${opt_quit}"
        "${opt_sh_tips}"
        "${opt_sh_installed}"
        "${opt_sh_listen}" 
        "${opt_sh_process}" 
        "${opt_sh_svcs}"
        "${opt_launch_users_gui}"
        "${opt_audit_users}"
        "${opt_launch_updates_config_gui}"
        "${opt_purge_tools}"
        "${opt_purge_services}"
        "${opt_update}"
        "${opt_rm_snap}" 
        "${opt_set_ssh}"
        "${opt_set_banners}" 
        "${opt_set_account_policies}"
        "${opt_set_audit}"
        "${opt_set_kernel}" 
        "${opt_set_shm}"
        "${opt_find_media_files}"
        "${opt_delete_media_files}"
        "${opt_protect_install_av}"
        "${opt_protect_run_av}"
        "${opt_protect_install_firewall}"
        "${opt_protect_conf_firewall}"
        "${opt_clean_menu}"
        "${opt_show_functions}" 
        )
    num_options="${#A_OPTIONS[@]}"
    # array for tracking number of runs per option, initialised to 0 using shell paremeter expansion syntax
    # https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion
    a_option_runs=("${A_OPTIONS[@]/*/0}")
}

# 3
#######################################
# executes an option when called
# Globals:
#   logpath
#   reconpath
# Arguments:
#   $1 option by name
# Outputs:
#   Nil
#######################################
function execute_option(){
    case ${1} in
        "${opt_sh_tips}")
            cat "$(dirname "${0}")/tips.md"
            ;;
        ### recon
        "${opt_sh_installed}")
            write_log_entry "${logpath}" "Executed: ${opt_sh_installed}"
            echo "you can also use 'apt list --installed' "
            check_recently_installed
            echo "Check here for output: ${recon_install_path}"
            ;;
        "${opt_sh_process}")
            write_log_entry "${logpath}" "Executed: ${opt_sh_process}" 
            echo "Try 'pstree -p' or 'ps -aux' to list processes anytime"
            echo "If you have a suspect program running, you can see what started it"
            #printf "T\n"
            recon_get_processes
            echo "Check here for output: ${recon_processes_path}"
            # TODO analyse
            ;;
        "${opt_sh_listen}")
            write_log_entry "${logpath}" "Executed: ${opt_sh_listen}" 
            printf "NOTE: Any process names not in colour below are interesting\n"
            recon_get_listening
            printf "\nCheck here for output: ${recon_listening_path}\n"
            # TODO analyse
            ;;
        "${opt_sh_svcs}")
            write_log_entry "${logpath}" "Executed: ${opt_sh_svcs}" 
            echo "'systemctl --type=service' To show services use "
            echo "Look for services like apache, ftpd"
            echo "'systemctl --type=service | egrep -i 'running'' Use grep to filter output."
            echo "'systemctl status ufw' to see the status of a service like ufw"
            recon_get_services
            echo "Check here for output: ${recon_services_path}"
            ;;
        ### users
        "${opt_launch_users_gui}")
            write_log_entry "${logpath}" "Executed: ${opt_launch_users_gui}"
            launch_settings_users_gui
            ;;
        "${opt_audit_users}")
            write_log_entry "${logpath}" "Executed: ${opt_audit_users}"
            global_menu_reply_state="${REPLY}"
            # 
            if [[ ${a_option_runs[${global_menu_reply_state}]} == 0 ]]; then
                printf "USAGE:\n"
                printf "1. For this to work, you must edit the file: \n"
                printf "2. reccomend doing a dry run before autofix!\n"
                printf "3. after the dry run, check if the unauthorised user has files or evidence for forensics questions\n"
                printf "NOTE:\n1. You may need to update the password for a user with insecure password by using 'sudp paswd <username>'"
            fi
            read -p "Do you want to autofix the users? (Y, default is no, dry run only): "
            if [[ ${REPLY} =~ 'y' ]]; then 
                audit_users "$(dirname "${0}")/users.conf" 'true'
            else
                audit_users "$(dirname "${0}")/users.conf" 'false'
            fi
            REPLY="${global_menu_reply_state}"
            ;;
        #### applications
        "${opt_launch_updates_config_gui}")
            write_log_entry "${logpath}" "Executed: ${opt_launch_updates_config_gui}"
            printf "Launching gui now\n"
            printf "Go to updates tab, Enable security updates, and auto install\n"
            printf "\n"
            launch_updates_config_gui
            ;;
        "${opt_update}")
            write_log_entry "${logpath}" "Executed: ${opt_update}" 
            apt upgrade && apt update -y
            ;;
        "${opt_purge_tools}")
            write_log_entry "${logpath}" "Executed: ${opt_purge_tools}" 
            # TODO read to confirm
            apt_purge_tools
            apt_purge_games
            snap_remove
            printf "apt and snap tools uninstalled\n"
            ;;
        "${opt_purge_services}")
            write_log_entry "${logpath}" "Executed: ${opt_purge_services}"
            apt_purge_servcies
            printf "Services uninstalled\n"
            ;;
        "${opt_rm_snap}")
            write_log_entry "${logpath}" "Executed: ${opt_rm_snap}"
            global_menu_reply_state="${REPLY}"
            read -p "Do you really want to remove the snap manager? (y, default is no, list snaps only): "
            if [[ ${REPLY} =~ 'y' ]]; then 
                snap_remove_all_installed
            else
                (snap list)
            fi            
            REPLY="${global_menu_reply_state}"
            ;;
        ### secure config
        "${opt_set_ssh}")
            write_log_entry "${logpath}" "Executed: ${opt_set_ssh}"
            config_ssh_banner "./rsc/banner.txt"
            config_ssh
            printf "SSH configured\n"
            ;;
        "${opt_set_banners}")
            write_log_entry "${logpath}" "Executed: ${opt_set_banners}"
            set_motd_terminal
            set_gnome_login_banner
            set_banner_permissions
            echo "Banners configured."
            ;;
        "${opt_set_account_policies}")
            write_log_entry "${logpath}" "Executed: ${opt_set_account_policies}"
            lock_root
            set_login_defaults
            set_lockout_policy
            disable_guest_account
            set_password_complexity
            echo "Account policies configured."
            ;;
        "${opt_set_audit}")
            write_log_entry "${logpath}" "Executed: ${opt_set_audit}"
            remove_bash_history_symlink
            ## todo some more
            echo "Audit policies configured."
            ;;
        "${opt_set_kernel}")
            write_log_entry "${logpath}" "Executed: ${opt_set_kernel}"
            set_kernel_networking_security
            set_kernel_sysctlconf
            set_kernel_memory_protections
            echo "Reccomended secure kernel defaults configured."
            ;;
        "${opt_set_shm}")
            write_log_entry "${logpath}" "Executed: ${opt_set_shm}" 
            disable_shm
            printf "\dev\shm is now read only.\n"
            ;;
        ### forensics
        "${opt_find_media_files}")
            write_log_entry "${logpath}" "Executed: ${opt_find_media_files}"
            global_menu_reply_state="${REPLY}"
            read -p "Enter a path to search like '/home': "
            find_media_files_by_type "${REPLY}"
            REPLY="${global_menu_reply_state}"
            echo "Find media files by type completed."
            ;;
        "${opt_delete_media_files}")
            write_log_entry "${logpath}" "Executed: ${opt_find_media_files}"
            global_menu_reply_state="${REPLY}"
            read -p "Enter a path to delete files from like '/home': "
            file_delete_path="${REPLY}"
            read -p "Enter an extension to delete like 'mp3': "
            file_delete_extentions="${REPLY}"
            delete_media_by_extension  "${file_delete_extentions}"  "${file_delete_path}"
            REPLY="${global_menu_reply_state}"
            echo "DELETE media files by extension ${file_delete_extentions} completed."
            ;;
        ## Protect
        "${opt_protect_install_av}")
            write_log_entry "${logpath}" "Executed: ${opt_protect_install_av}"
            install_clamav
            printf "clamscan installed\nRun 'clamtk' to run a scan from gui, remember it is slow!\n"
            printf "'clamscan -i /' to run a scan on the whole system, if you know the path, specify it\n\n"
            ;;
        "${opt_protect_run_av}")
            write_log_entry "${logpath}" "Executed: ${opt_protect_run_av}"
            printf "'clamscan -i /' to run a scan on the whole system, if you know the path, specify it\n\n"
            ;;
        "${opt_protect_install_firewall}")
            write_log_entry "${logpath}" "Executed: ${opt_protect_install_firewall}"
            install_enable_firewall
            ;;
        "${opt_protect_conf_firewall}")
            write_log_entry "${logpath}" "Executed: ${opt_protect_conf_firewall}"
            gufw &
            ;;
        ## fightclub specific
        "${opt_clean_menu}")
            print_menu
            ;;
        "${opt_show_functions}")
            printf "Caution, not all of these functions are tested.\n"
            a_functions=("$(declare -F | awk '{print $3}')")
            echo "${a_functions}"
            #read -p "Enter a function name to run: "
            ;;
        "${opt_quit}" | 'q' | 'Q')
            write_log_entry "${logpath}" "___FINISHED SCBC FIGHTCLUB___" 
            # print check logfiles
            printf "Thank you for using SCBC FightClub!\n\n"
            exit 0
            ;;
        "*")
            printf "Enter a number from above range only\n"
            ;;
    esac
    # increment option run count
    (( a_option_runs["${REPLY}"]++ ))
}



#######################################
# prints the logo to stdout
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function print_logo(){
# SCBC FightClub
logo_b64="ICAgX19fX19fX19fX19fICBfX19fXyAgX19fX18gICAgICBfXyAgIF9fICBfX19fX19fICAgICBf\
XyAKICAvIF9fLyBfX18vIF8gKS8gX19fLyAvIF9fKF8pX18gXy8gLyAgLyAvXy8gX19fLyAvXyBf\
Xy8gLyAKIF9cIFwvIC9fXy8gXyAgLyAvX18gIC8gXy8vIC8gXyBgLyBfIFwvIF9fLyAvX18vIC8g\
Ly8gLyBfIFwKL19fXy9cX19fL19fX18vXF9fXy8gL18vIC9fL1xfLCAvXy8vXy9cX18vXF9fXy9f\
L1xfLF8vXy5fXy8KICAgICAgICAgICAgICAgICAgICAgICAgICAgL19fXy8gICAgICAgICAgICAg\
ICAgICAgICAgICAgICAKCg=="
echo "${logo_b64}" | base64 -d
echo "A cyber taipan helper by ding0t. Version: ${script_version}"
echo ""
}


#######################################
# Displays a menu - when nort using select funciton
# Globals:
#   A_OPTIONS
# Arguments:
#   $0 itself
# Outputs:
#   Nil
#######################################
function print_menu(){
    # Logo
    print_logo
    echo "USAGE:"
    echo "1. Options that make changes will prompt for permission."
    echo "2. Look for log files in the same directory this script was run from."
    echo "3. Config files are backed up before change next to their original location. Check ${logpath} for records."
    echo "4. Option run count updates only on a menu refresh."
    echo ""
    echo "OPTIONS:"
    #  Show options like
    # 1) "Option"
    for i in "${!A_OPTIONS[@]}"; do
        col1="${i})"
        col3="${A_OPTIONS[${i}]}"
        col2="(Runs: ${a_option_runs[${i}]})"
        #printf "${i}) ${A_OPTIONS[${i}]}\t\t\t(Run count: ${a_option_runs[${i}]})\n"
        #paste <(printf %s "${col1}") <(printf %s "${col3}")
        printf "${col1} ${col2}  ${col3}\n"
    done
}


#######################################
# gets menu item by number - when not using select funciton
# Globals:
#   A_OPTIONS
#   REPLY
# Arguments:
#
# Outputs:
#   read sets $REPLY
#######################################
function get_user_selected_option(){
    num_options="${#A_OPTIONS[@]}"
    read -p "Enter a action to take 0 to ${num_options}:"
    if (( "${REPLY}" >= 0 &&  "${REPLY}" <= num_options )); then
        execute_option "${A_OPTIONS["${REPLY}"]}" 
    fi
}