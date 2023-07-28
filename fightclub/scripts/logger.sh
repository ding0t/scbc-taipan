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
