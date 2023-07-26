#! /bin/bash
#
# ABOUT
# Setup and Ubuntu or Debian host with a mock challenge
#
# Author: ding0t
#
# REFERENCES
# https://google.github.io/styleguide/shellguide.html
#######################################

# Check if running as root
if [[ $EUID -ne 0 ]]
then
  printf "You must use sudo to run this script as root. Exiting.\n"
  exit 1
fi

# import functions from libs directory
source $(dirname "${0}")/libs/users.sh
source $(dirname "${0}")/libs/install.sh
source $(dirname "${0}")/libs/ssh_config.sh


# setup config files
script_dir="$(dirname "${0}")"
users_csv_file="/config/users.csv"
users_csv_path="${script_dir}${users_csv_file}"

# execute changes
printf "Setting up playground.\n"
add_users "${users_csv_path}"
unlock_root "mansplain_223"
edit_sudoers
install_apt
install_snap
get_icap
modify_ufw
config_ssh
clear


