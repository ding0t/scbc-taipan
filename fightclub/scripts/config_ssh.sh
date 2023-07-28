#!/usr/bin/env bash
#
# ABOUT
# These functions configure ssh
# 
# PROVIDES
# config_ssh

#######################################
# what
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function config_ssh(){
    # files
    issue_file="/etc/issue.net"
    ssh_config_file="/etc/ssh/sshd_config"

    # set up a banner message
    printf  "WARNING\!\nUnauthorised access is prohibited.\n" >> $issue_file

    # configure ssh config
    sed -i '/Banner/ c\Banner /etc/issue.net' $ssh_config_file
    # allow only ssh2
    printf "Protocol 2" >> $ssh_config_file
    # can change default port
    sed -i '/Port 22/ c\Port 43122' $ssh_config_file
    # auth settings 
    sed -i '/LoginGraceTime/ c\LoginGraceTime 20' $ssh_config_file
    sed -i '/PermitRootLogin/ c\PermitRootLogin no' $ssh_config_file
    sed -i '/MaxAuthTries/ c\MaxAuthTries 3' $ssh_config_file
    sed -i '/PasswordAuthentication/ c\PasswordAuthentication no' $ssh_config_file
    # Disconnect automatically idle sessions
    sed -i '/ClientAliveInterval/ c\ClientAliveInterval 60' $ssh_config_file
    sed -i '/ClientAliveCountMax/ c\ClientAliveCountMax 3' $ssh_config_file

    # if we have only specific users that need ssh
    #AllowUsers <username> 

    # restart sshd to apply changes
    systemctl restart sshd
    write_log_entry "${logpath}" "${0}"
}

## If run on its own uncomment the below line:
#config_ssh
