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
opt_update="Update system and applications"
opt_purge_tools="Purge hacker tools"
opt_set_ssh="Configure SSH"
opt_sh_listen="Show listening connections"
opt_sh_svcs="Show services"
opt_set_kernel="Configure kernel defaults"
opt_set_shm="Disable /dev/shm"
opt_quit="Quit"
# oreder of array will set order of options
A_OPTIONS=("${opt_update}" "${opt_purge_tools}" \
"${opt_set_ssh}" "${opt_set_kernel}" "${opt_set_shm}" \
"${opt_sh_listen}" "${opt_sh_svcs}" \
"${opt_quit}")


#Menu Selections
# can use "${!A_OPTIONS[@]}"  to iteratre by index vs value
select option in "${A_OPTIONS[@]}"; do
	case ${option} in
		"${opt_update}")
			echo "$(date +'%m/%d/%Y %r'): Executed ${opt1}" >> "${logpath}"
			apt upgrade && apt update -y
			;;
		"${opt_purge_tools}")
			echo "$(date +'%m/%d/%Y %r'): Executed ${opt2}" >> "${logpath}"
			apt_purge_tools
			;;
		"${opt_set_ssh}")
			echo "$(date +'%m/%d/%Y %r'): Executed ${opt3}" >> "${logpath}"
			config_ssh
			;;
		"${opt_sh_listen}")
			echo "$(date +'%m/%d/%Y %r'): Executed ${opt4}" >> "${logpath}"
			ss -tlpn | tee >> "${logpath}"
			# TODO analyse
			;;
		"${opt_sh_svcs}")
			echo "$(date +'%m/%d/%Y %r'): Executed ${opt5}" >> "${logpath}"
			systemctl --type=service | tee >> "${logpath}"
			# TODO analyse against a list
			;;
		"${opt_set_kernel}")
			echo "$(date +'%m/%d/%Y %r'): Executed ${opt6}" >> "${logpath}"
			set_kernel_networking_security
			set_kernel_sysctlconf
			;;
		"${opt_set_shm}")
			echo "$(date +'%m/%d/%Y %r'): Executed ${opt7}" >> "${logpath}"
			disable_shm
			;;
		"${opt_quit}")
			echo "$(date +'%m/%d/%Y %r'): Executed ${opt_quit}" >> "${logpath}"
			break
			;;
	esac
	# Reset REPLY variable to NULL used by select to reprint menu
	REPLY=NULL
done

