#!/usr/bin/env bash
#
# ABOUT
# These functions configure user accounts and passwords
# 
# PROVIDES
# lock_root
# set_login_defaults
# set_lockout_policy
# set_password_complexity
# disable_guest_account

#######################################
# lock root acount
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function lock_root(){
    # /etc/shadow username:!: means locked
    passwd -l root
    
}

#######################################
# configure password complexity
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function set_login_defaults(){
    passwd_logins_config_file="/etc/login.defs"
    create_backup_of_file "${passwd_logins_config_file}"
    sed -i '/PASS_MAX_DAYS/ c\PASS_MAX_DAYS 90' "${passwd_logins_config_file}"
    sed -i '/PASS_MIN_DAYS/ c\PASS_MIN_DAYS 10' "${passwd_logins_config_file}"
    sed -i '/PASS_WARN_AGE/ c\PASS_WARN_AGE 7' "${passwd_logins_config_file}"
    sed -i '/LOGIN_TIMEOUT/ c\LOGIN_TIMEOUT 60' "${passwd_logins_config_file}"
    sed -i '/CHFN_RESTRICT/ c\CHFN_RESTRICT rwh' "${passwd_logins_config_file}"
    create_edited_config_mark "${passwd_logins_config_file}"
}

#######################################
# set account lockout policy
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
# Ref: https://askubuntu.com/questions/59459/how-do-i-enable-account-lockout-using-pam-tally
#######################################
function set_lockout_policy(){
    pam_auth_filename="/etc/pam.d/common-auth"
    create_backup_of_file "${pam_auth_filename}"
    install -D -m 644 "$(dirname "${0}")/rsc/common-auth" "${pam_auth_filename}"
    create_edited_config_mark "${pam_auth_filename}"
}

#######################################
# set account lockout policy
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
# Ref: https://askubuntu.com/questions/59459/how-do-i-enable-account-lockout-using-pam-tally
#######################################
function disable_guest_account(){
    lightdm_config_file="/usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf"
    disable_guest_str="allow-guest=false"
    disable_autologin_str="autologin-user=false"
    create_backup_of_file "${lightdm_config_file}" 
    grep -qiF "${disable_guest_str}" "${lightdm_config_file}" &&
        sed -i 's/\${disable_guest_str}/\${disable_guest_str}/' "${lightdm_config_file}" || echo "${disable_guest_str}" >> "${lightdm_config_file}"
    grep -qiF "${disable_autologin_str}" "${lightdm_config_file}" &&
        sed -i 's/\${disable_autologin_str}/\${disable_autologin_str}/' "${lightdm_config_file}" || echo "${disable_autologin_str}" >> "${lightdm_config_file}"
    create_edited_config_mark "${lightdm_config_file}" 
}


#######################################
# Enforce password complexity
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function set_password_complexity(){
    pam_password_filename="/etc/pam.d/common-password"
    password_quality_filename="/etc/security/pwquality.conf"
    #
    create_backup_of_file "${pam_password_filename}"
    create_backup_of_file "${password_quality_filename}"
    #
    sed '/pam_unix.so/ s/$/ remember=5 minlen=12/' "${pam_password_filename}"
    create_edited_config_mark "${pam_password_filename}"
    #
    sed -i '/minlen/ c\minlen = 12' "${password_quality_filename}"
    sed -i '/ucredit/ c\ucredit = -1' "${password_quality_filename}"
    sed -i '/lcredit/ c\lcredit = -1' "${password_quality_filename}"
    sed -i '/dcredit/ c\dcredit = -1' "${password_quality_filename}"
    sed -i '/ocredit/ c\ocredit = -1' "${password_quality_filename}"
    sed -i '/usercheck/ c\usercheck = 1' "${password_quality_filename}"
    sed -i '/enforcing/ c\enforcing = 1' "${password_quality_filename}"
    create_edited_config_mark "${password_quality_filename}"
    
}
