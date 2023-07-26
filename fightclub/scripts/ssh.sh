#! /bin/bash

# author: ding0t SCBC
# purpose: to secure ssh config
# assumes: sudo
# status: untested

# files
issue_file="/etc/issue.net"
ssh_config_file="/etc/ssh/sshd_config"

# set up a banner message
printf "writing new banner messge:\n"
printf  "WARNING\!\nUnauthorised access is prohibited.\n" | sudo tee $issue_file

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
printf "restarting sshd\n"
systemctl restart sshd
printf "done!\n"
