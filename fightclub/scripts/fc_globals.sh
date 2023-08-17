#!/usr/bin/env bash
#
# ABOUT
# These functions remove applications
# 
# PROVIDES
script_version="2023_08_17a"
script_dir="$(dirname "${0}")"
# log files
logfile="/logfight.log"
logpath="${script_dir}${logfile}"
reconpath="${script_dir}/recondata.txt"
recon_services_path="${script_dir}/recon_services.txt"
recon_processes_path="${script_dir}/recon_processes.txt"
recon_listening_path="${script_dir}/recon_listening.txt"
recon_install_path="${script_dir}/recon_install.txt"
user_audit_path="${script_dir}/users_audit.txt"
#
edited_config_mark="# edited by SCBC taipan"
global_menu_reply_state='0'

