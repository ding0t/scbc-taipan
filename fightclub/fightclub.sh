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
#
# REFERENCES
# https://secscan.acron.pl/centos7/1/7/2
# https://secscan.acron.pl/ubuntu1604/start
#
# TODO
# Provide feedback of actions taken to stdout (clearing menu atm, reprint or save some output, or have a menu when in an option)
#
# copy any configs changed
#
# recon system
# backup - key files
# patch - os
# patch - applications
# check users and permissions
# secure config - kernel
# secure config - services
# secure config - sudoers
# remove - hacker tools
# remove - non-business applications
# remove - unused services
# remove - non-business files
# protect - enable firewall, setup
# protect - enable av, setup, execute scan


# Check if running as root
if [[ $EUID -ne 0 ]]
then
  printf "You must use sudo to run this script as root. Exiting.\n"
  exit 1
fi

#trap '' SIGINT SIGQUIT SIGTSTP

# import functions from scripts directory
# global variables
source "$(dirname "${0}")/scripts/fc_globals.sh"
# menu setup and execution
source "$(dirname "${0}")/scripts/fc_menu.sh"
source "$(dirname "${0}")/scripts/fc_logger.sh"
# recon
source "$(dirname "${0}")/scripts/recon.sh"
# check users 

# secure config
source "$(dirname "${0}")/scripts/config_ssh.sh"
source "$(dirname "${0}")/scripts/config_accounts.sh"
source "$(dirname "${0}")/scripts/config_applications.sh"
source "$(dirname "${0}")/scripts/config_banners.sh"
source "$(dirname "${0}")/scripts/config_filesystem.sh"
source "$(dirname "${0}")/scripts/config_kernel.sh"
source "$(dirname "${0}")/scripts/config_audit.sh"

# apt and snap and services
source "$(dirname "${0}")/scripts/app_update_apt.sh"
source "$(dirname "${0}")/scripts/app_rm_applications.sh"
source "$(dirname "${0}")/scripts/app_rm_snap.sh"
# protect
source "$(dirname "${0}")/scripts/protect_antivirus.sh"
source "$(dirname "${0}")/scripts/protect_firewall.sh"

# forensics
source "$(dirname "${0}")/scripts/forensics.sh"

# lets get going...
write_log_entry "${logpath}" "=== STARTING SCBC FIGHTCLUB ==="
print_clean_menu
# Sow menu and execute options
while :;do
	# User instructions
	# ask user
    read -p "Enter action 0 to $((num_options-1)): "
	# asess reply
    if (( "${REPLY}" >= 0 &&  "${REPLY}" <= num_options )); then
		#printf "Executing option "${REPLY}""
        execute_option "${A_OPTIONS["${REPLY}"]}" 
	else 
		printf "Enter a number from above range only\n"
    fi
done


