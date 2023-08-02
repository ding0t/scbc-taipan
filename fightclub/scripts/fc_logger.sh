#!/usr/bin/env bash
#
# ABOUT
# These functions provide logging for the script, and backup of orig configs
# 
# PROVIDES
# write_log_entry
# create_edited_config_mark
# create_backup_of_file

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
function write_log_entry(){
    printf "$(date +'%m/%d/%Y %r'): ${2}\n" >> "${1}"
}

#######################################
# creates a flag in file to mark SCBC edits
# Globals:
#   nil
# Arguments:
#   $1 the file to mark
#
# Outputs:
#   marker to selected file
#######################################
function create_edited_config_mark(){
    # 
    echo "${edited_config_mark}" >> "${1}"
}

#######################################
# creates backup of a file
# Globals:
#   nil
# Arguments:
#   $1 the file to backup
#
# Outputs:
#   new file
#######################################
function create_backup_of_file(){
    # could also use grep -qv
    if ! [[ $(grep -q -i "${edited_config_mark}" "${1}") ]] ; then
        cp "${1}" "${1}.orig"
    fi
}
