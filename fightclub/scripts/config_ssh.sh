#!/usr/bin/env bash
#
# ABOUT
# These functions configure ssh
#
# REFERENCES
# https://help.ubuntu.com/community/StricterDefaults
# 
# PROVIDES
# config_ssh_banner
# config_ssh

function config_ssh_banner(){
    # set up a banner message
    issue_file="/etc/issue.net"
    create_backup_of_file "${issue_file}"
    tee -a "${issue_file}" < EOF
***************************************************************************
                            NOTICE TO USERS


This computer system is the private property of its owner, whether
individual, corporate or government.  It is for authorized use only.
Users (authorized or unauthorized) have no explicit or implicit
expectation of privacy.

Any or all uses of this system and all files on this system may be
intercepted, monitored, recorded, copied, audited, inspected, and
disclosed to your employer, to authorized site, government, and law
enforcement personnel, as well as authorized officials of government
agencies, both domestic and foreign.

By using this system, the user consents to such interception, monitoring,
recording, copying, auditing, inspection, and disclosure at the
discretion of such personnel or officials.  Unauthorized or improper use
of this system may result in civil and criminal penalties and
administrative or disciplinary action, as appropriate. By continuing to
use this system you indicate your awareness of and consent to these terms
and conditions of use. LOG OFF IMMEDIATELY if you do not agree to the
conditions stated in this warning.

****************************************************************************      
EOF
chown root:root "${issue_file}"
chmod 644 "${issue_file}"
}

#######################################
# Reconfigure ssh settings and restart ssh
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function config_ssh(){
    # files
    ssh_config_file="/etc/ssh/sshd_config"
    create_backup_of_file "${ssh_config_file}"
    # configure ssh config
    sed -i '/Banner/ c\Banner /etc/issue.net' "${ssh_config_file}"
    # allow only ssh2
    printf "Protocol 2" >> "${ssh_config_file}"
    # can change default port
    #sed -i '/Port 22/ c\Port 43122' "${ssh_config_file}"
    # auth settings 
    sed -i '/LoginGraceTime/ c\LoginGraceTime 20' "${ssh_config_file}"
    sed -i '/PermitRootLogin/ c\PermitRootLogin no' "${ssh_config_file}"
    sed -i '/MaxAuthTries/ c\MaxAuthTries 3' "${ssh_config_file}"
    sed -i '/PasswordAuthentication/ c\PasswordAuthentication no' "${ssh_config_file}"
    # Disconnect automatically idle sessions
    sed -i '/ClientAliveInterval/ c\ClientAliveInterval 60' "${ssh_config_file}"
    sed -i '/ClientAliveCountMax/ c\ClientAliveCountMax 3' "${ssh_config_file}"

    # if we have only specific users that need ssh
    #AllowUsers <username> 

    # restart sshd to apply changes
    systemctl restart sshd
    write_log_entry "${logpath}" "${0}"
}

## If run on its own uncomment the below line:
#config_ssh
