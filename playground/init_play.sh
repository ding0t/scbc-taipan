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

source $(dirname "${0}")/libs/users.sh
script_dir="$(dirname "${0}")"
users_csv_file="/config/users.csv"
users_csv_path="${script_dir}${users_csv_file}"

echo "${users_csv_path}"

