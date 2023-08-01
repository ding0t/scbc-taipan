#!/usr/bin/env bash
#
# ABOUT
# These functions remove snap 
# 
# PROVIDES
# apt_purge_tools
# apt_purge_servcies
# snap_remove

#######################################
# Update default browser]
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function set_default_browser(){
    update-alternatives --config x-www-browser
}