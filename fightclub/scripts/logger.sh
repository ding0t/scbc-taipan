#!/usr/bin/env bash

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

    echo "$(date +'%m/%d/%Y %r'): ${2}" >> "${1}"
}
