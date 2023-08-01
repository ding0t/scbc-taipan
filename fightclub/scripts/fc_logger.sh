#!/usr/bin/env bash
#
# ABOUT
# These functions provide logging for the script
# 
# PROVIDES



#######################################
# writes a log line
# Globals:
#   nil
# Arguments:
#   $1 the logfile path
#   $2 the log message
# Outputs:
#   Nil
#######################################
# setup config files


function write_log_entry(){
    printf "$(date +'%m/%d/%Y %r'): ${2}\n" >> "${1}"
}


#######################################
# creates backup of a file
# Globals:
#   nil
# Arguments:
#   $1 the file to backup
#
# Outputs:
#   Nil
#######################################
function create_backup_of_file(){
    # 
    cp "${1}" "${1}.orig"
}
