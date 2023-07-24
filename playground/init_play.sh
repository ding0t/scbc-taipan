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
  printf "You must use sudo to run this script as root. Exiting."
  exit 1
fi

source $(dirname "$0")/libs/users.sh
users_csv_file= '$(dirname "$0")/config/users.csv'

printf ${users_csv_file}

