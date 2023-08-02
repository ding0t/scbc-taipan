#!/usr/bin/env bash
#
# ABOUT
# These functions remove applications
# 
# PROVIDES

script_dir="$(dirname "${0}")"
logfile="/logfight.log"
logpath="${script_dir}${logfile}"
reconfile="/recondata.txt"
reconpath="${script_dir}${reconfile}"
edited_config_mark="# edited by SCBC taipan"
global_menu_reply_state='0'

