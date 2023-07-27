#!/usr/bin/env bash
#
# ABOUT
# These functions recon the system
# 
# PROVIDES
# get_running_processes
# get_services
# get_listening

#######################################
# what
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################


grep -i sudo /etc/group
grep -i adm /etc/group
