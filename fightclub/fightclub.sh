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

#trap '' SIGINT SIGQUIT SIGTSTP

# import functions from scripts directory
source "$(dirname "${0}")/scripts/config_ssh.sh"
source "$(dirname "${0}")/scripts/config_users.sh"
source "$(dirname "${0}")/scripts/apt.sh"
source "$(dirname "${0}")/scripts/config_kernel.sh"
source "$(dirname "${0}")/scripts/logger.sh"
source "$(dirname "${0}")/scripts/menu.sh"

# lets get going...
write_log_entry "${logpath}" "=== STARTING SCBC FIGHTCLUB ==="
# Sow menu and execute options
while :;do
	# User instructions
	print_menu
	# ask user
    read -p "Enter a action to take 1 to ${num_options}:"
	# asess reply
    if (( "${REPLY}" >= 0 &&  "${REPLY}" <= num_options )); then
        execute_option "${A_OPTIONS["${REPLY}"]}" 
	else 
		printf "Enter a number from above range only\n"
    fi
done


