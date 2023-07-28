#!/usr/bin/env bash
#
# ABOUT
# This script can be used to automatically configure settings for SCBC Taipan
#
# USAGE
# 1. Clone the git repo
# 2. EIther `chmod +x`` this script or execute by calling bash explicity with this script as an argument like:
# 3a. `sudo bash fightclub.sh` or
# 3b. `sudo ./fightclub.sh`
# 4. Select a option by typing the number then enter to view help and then execute that option
#
# REQUIREMENTS
# 1. All of the scipts in ./scripts folder
# 1. Run as sudo (root priviliges)

# Check if running as root
if [[ $EUID -ne 0 ]]
then
  printf "You must use sudo to run this script as root. Exiting.\n"
  exit 1
fi

# setup config files
script_dir="$(dirname "${0}")"
logfile="/logfight.log"
logpath="${script_dir}${logfile}"
reconfile="/recondata.txt"
reconpath="${script_dir}${reconfile}"

trap '' SIGINT SIGQUIT SIGTSTP

# import functions from scripts directory
source $(dirname "${0}")/scripts/config_ssh.sh
source $(dirname "${0}")/scripts/config_users.sh
source $(dirname "${0}")/scripts/apt.sh
# snap
source $(dirname "${0}")/scripts/config_kernel.sh
source $(dirname "${0}")/scripts/logger.sh


# define menu options for options array
# This text will be used in the case statement, keep short
# show state
opt_sh_listen="Show listening connections"
opt_sh_svcs="Show services"
opt_sh_process="Show running processes"
# applications
opt_update="Update system and applications"
opt_purge_tools="Purge hacker tools"
# configure settings
opt_set_ssh="Configure SSH"
opt_set_kernel="Configure kernel defaults"
opt_set_shm="Disable /dev/shm"
# script operations
opt_quit="Quit"

# order of array will set order of options
# Place them in reccomended order of execution
A_OPTIONS=("${opt_update}" 
"${opt_sh_listen}" 
"${opt_sh_process}" 
"${opt_sh_svcs}"
"${opt_purge_tools}" 
"${opt_set_ssh}" 
"${opt_set_kernel}" 
"${opt_set_shm}" 
"${opt_quit}" 
)

write_log_entry "${logpath}" "=== STARTING SCBC FIGHTCLUB ==="
#Menu Selections
while true; do
	# can use "${!A_OPTIONS[@]}"  to iteratre by index vs value or use $REPLY
	# break forces the menu to be reprinted 
	printf "Logs are written to: ${logpath}\n"
	select option in "${A_OPTIONS[@]}"; do
		case ${option} in
			"${opt_update}")
				write_log_entry "${logpath}" "Executed: ${opt1}" 
				apt upgrade && apt update -y
				break
				;;
			"${opt_purge_tools}")
				write_log_entry "${logpath}" "Executed: ${opt2}" 
				apt_purge_tools
				snap_remove
				break
				;;
			"${opt_set_ssh}")
				write_log_entry "${logpath}" "Executed: ${opt3}" 
				config_ssh
				break
				;;
			"${opt_sh_process}")
				write_log_entry "${logpath}" "Executed: ${opt4}" 
				ps -aux | tee >> "${reconpath}"
				# TODO analyse
				break
				;;
			"${opt_sh_listen}")
				write_log_entry "${logpath}" "Executed: ${opt4}" 
				ss -tlpn | tee >> "${reconpath}"
				# TODO analyse
				break
				;;
			"${opt_sh_svcs}")
				write_log_entry "${logpath}" "Executed: ${opt5}" 
				systemctl --type=service | tee >> "${reconpath}"
				# TODO analyse against a list
				break
				;;
			"${opt_set_kernel}")
				write_log_entry "${logpath}" "Executed: ${opt6}"
				set_kernel_networking_security
				set_kernel_sysctlconf
				break
				;;
			"${opt_set_shm}")
				write_log_entry "${logpath}" "Executed: ${opt7}" 
				disable_shm
				break
				;;
			"${opt_quit}")
				write_log_entry "${logpath}" "___FINISHED SCBC FIGHTCLUB___" 
				break 2
				;;
			"*")
				printf "Enter a number from above selection only\n"
				break
				;;
		esac
	done
done

