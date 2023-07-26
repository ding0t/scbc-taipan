#! /bin/bash

# author: ding0t SCBC
# purpose: to secure ssh config
# assumes: sudo
# status: untested
function config_ssh(){
    # files
    issue_file="/etc/issue.net"
    ssh_config_file="/etc/ssh/sshd_config"

    # set up a banner message
    printf  " " > $issue_file

    # configure ssh config
    sed -i '/Banner/ c\#Banner /etc/issue.net' $ssh_config_file
    # allow only ssh2
    #printf "Protocol 2" >> $ssh_config_file
    # can change default port
    sed -i '/Port / c\Port 22' $ssh_config_file
    # auth settings 
    sed -i '/LoginGraceTime/ c\#LoginGraceTime 20' $ssh_config_file
    sed -i '/PermitRootLogin/ c\PermitRootLogin yes' $ssh_config_file
    sed -i '/MaxAuthTries/ c\#MaxAuthTries 3' $ssh_config_file
    sed -i '/PasswordAuthentication/ c\PasswordAuthentication yes' $ssh_config_file
    # Disconnect automatically idle sessions
    sed -i '/ClientAliveInterval/ c\#ClientAliveInterval 60' $ssh_config_file
    sed -i '/ClientAliveCountMax/ c\#ClientAliveCountMax 3' $ssh_config_file

    # if we have only specific users that need ssh
    #AllowUsers <username> 

    # restart sshd to apply changes
    systemctl restart sshd
}
