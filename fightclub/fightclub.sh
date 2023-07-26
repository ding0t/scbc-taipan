#! /bin/bash

# Check if running as root
if [[ $EUID -ne 0 ]]
then
  printf "You must use sudo to run this script as root. Exiting.\n"
  exit 1
fi

# setup config files
script_dir="$(dirname "${0}")"
logfile="/log/figtclub.log"
logpath="${script_dir}${logfile}"

trap '' SIGINT SIGQUIT SIGTSTP

# import functions from libs directory
source $(dirname "${0}")/scripts/ssh_config.sh
source $(dirname "${0}")/scripts/purge.sh
source $(dirname "${0}")/scripts/kernel.sh


echo "$(date +'%m/%d/%Y %r'): **Starting Script**" >> "${logpath}"

# start a menu loop
opt1="Update system and applications"
opt2="Purge hacker tools"
opt3="Configure SSH"
opt4="Show listening connections"
opt5="Show services"
opt6="Configure kernel defaults"
opt7="Disable /dev/shm"
opt8="Quit"
A_OPTIONS=("${opt1}" "${opt2}" "${opt3}" "${opt4}" "${opt5}" "${opt6}" "${opt7}")


#Menu Selections
select option in "${A_OPTIONS[@]}"; do
	case ${option} in
		"${opt1}")
			echo "$(date +'%m/%d/%Y %r'): Executed ${opt1}" >> "${logpath}"
			apt upgrade && apt update -y
			;;
		"${opt2}")
			echo "$(date +'%m/%d/%Y %r'): Executed ${opt2}" >> "${logpath}"
			apt_purge_tools
			;;
		"${opt3}")
			echo "$(date +'%m/%d/%Y %r'): Executed ${opt3}" >> "${logpath}"
			config_ssh
			;;
		"${opt4}")
			echo "$(date +'%m/%d/%Y %r'): Executed ${opt4}" >> "${logpath}"
			ss -tlpn | tee >> "${logpath}"
			# TODO analyse
			;;
		"${opt5}")
			echo "$(date +'%m/%d/%Y %r'): Executed ${opt5}" >> "${logpath}"
			systemctl --type=service | tee >> "${logpath}"
			# TODO analyse against a list
			;;
		"${opt6}")
			echo "$(date +'%m/%d/%Y %r'): Executed ${opt6}" >> "${logpath}"
			set_kernel_networking_security
			set_kernel_sysctlconf
			
			;;
		"${opt7}")
			echo "$(date +'%m/%d/%Y %r'): Executed ${opt7}" >> "${logpath}"
			disable_shm
			;;
		"${opt8}")
			echo "$(date +'%m/%d/%Y %r'): Executed ${opt8}" >> "${logpath}"
			break
			;;
	esac
done

