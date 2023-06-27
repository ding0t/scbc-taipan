# about
Run sheet

## todo
1. check coverage and order (reference labs)
1. check commands work

# resources
* [hardening](https://gist.github.com/hiqsociety/2a4c26123df181bcdd3f1a0d42c7ee03)
1. [](https://secscan.acron.pl/ubuntu1604/start)
2. [good checklist](https://github.com/03npan/cyberpatriot-linux-scripts/blob/main/CyberPatriot%20Ubuntu%20Checklist.txt)

# checklist
## system and applciation updates
### apt
Update early, remember an apt command will lock the updating until completed. If you get a lock error, the simplest fix is to reboot.
- [] check for apt updates and upgrade `sudo apt update`
- []
### Snap
1. Ensure auto snap updates are on `snap refresh --unhold`
1. Update snap now `sudo snap refresh`

## users and groups
Audit all users and groups to ensure they match policy. If you change a password, write it down in your notes! 
Use a password that meets strong password policy like : `STRONG_layser_7784`
### root user
- [] disable root `sudo -l root`

### other users
Iterate through each user on the system, and mark them off against the policy. Use the gui for this
- [] Should the user exist
- [] Are they supposed to be admin, change setting if needed in gui
- [] check user group membership `cmd`
- [] check their password strength
- [] before deleting user, check if they have any forensics questions, we may need data in their account
- [] delete the user if not needed

## firewall
- [] Check firewall status `sudo ufw status`
- [] Install if needed
- [] Enable logging

# Forensics questions
Read them and get an idea of what you need to know.
1. Are there any files you will need from a user directory (ie dont delete if first)


##  APT tracked updates in OS
1. Kick off an update early `sudo apt update && sudo apt upgrade`
   1. If no `apt` use `sudo apt-get update && sudo apt-get upgrade`
   1. ? Will `sudo apt dist-upgrade` be required?



# User management
Note: Before deleting a user account, check if it has files that need to be saved off for forensics questions.

## Audit each user
Audit user accounts and document 
1. all passwords
1. User accounts checked for:
   1. Should they exist?
   1. Permission (admin or standard)
   1. Password is ok (meets complexity, not same as username, etc)
   1. Other group membership

## Audit groups?

## Set password policies


# Malware scans

#  --- Uncleared below ---
# Firewall
    apt-get install ufw && ufw enable
## SSH settings
Turn off root in sshd_config (Covered)

    if grep -qF 'PermitRootLogin' /etc/ssh/sshd_config; then sed -i 's/^.*PermitRootLogin.*$/PermitRootLogin no/' /etc/ssh/sshd_config; else echo 'PermitRootLogin no' >> /etc/ssh/sshd_config; fi
    PermitRootLogin no
    ChallengeResponseAuthentication no
    PasswordAuthentication no
    UsePAM no
    PermitEmptyPasswords no
Possibly add port 22 to firewall? (i.e. only accept local connections)

    sudo ufw allow from 202.54.1.5/29 to any port 22
No keepalive or unattended sessions

    ClientAliveInterval 300
    ClientAliveCountMax 0
Disable obsolete rsh settings

    IgnoreRhosts yes
Check sshd_config file for correctness before restart:

    sudo sshd -t
## Lock root user (Covered)
    passwd -l root
## Change login chances (Covered)
    sed -i 's/PASS_MAX_DAYS.*$/PASS_MAX_DAYS 90/;s/PASS_MIN_DAYS.*$/PASS_MIN_DAYS 10/;s/PASS_WARN_AGE.*$/PASS_WARN_AGE 7/' /etc/login.defs
## Update PAM settings (Covered)
    echo 'auth required pam_tally2.so deny=5 onerr=fail unlock_time=1800' >> /etc/pam.d/common-auth
    apt-get install libpam-cracklib
    sed -i 's/\(pam_unix\.so.*\)$/\1 remember=5 minlen=8/' /etc/pam.d/common-password
    sed -i 's/\(pam_cracklib\.so.*\)$/\1 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1/' /etc/pam.d/common-password
## Set up auditing (Covered)
    apt-get install auditd && auditctl -e 1
## Check for weird admins
    mawk -F: '$1 == "sudo"' /etc/group
## Check for weird users
    mawk -F: '$3 > 999 && $3 < 65534 {print $1}' /etc/passwd
## Check for empty passwords
    mawk -F: '$2 == ""' /etc/passwd
## Check for non-root UID 0 users
    mawk -F: '$3 == 0 && $1 != "root"' /etc/passwd
## Remove anything samba-related
    apt-get remove .*samba.* .*smb.*
## Find music (probably in admin's Music folder) (Covered)
    find /home/ -type f \( -name "*.mp3" -o -name "*.mp4" \)
## Remove any downloaded "hacking tools" packages (Covered)
    find /home/ -type f \( -name "*.tar.gz" -o -name "*.tgz" -o -name "*.zip" -o -name "*.deb" \)
# Don't blink
## If it doesn't ask for apache2, nginx, etc., you can usually remove it
## Check services
### Install bum for a graphical interface
    apt-get install bum
## Set home directory perm's
    for i in $(mawk -F: '$3 > 999 && $3 < 65534 {print $1}' /etc/passwd); do [ -d /home/${i} ] && chmod -R 750 /home/${i}; done
# Blacklisted programs
    nmap zenmap apache2 nginx lighttpd wireshark tcpdump netcat-traditional nikto ophcrack
# Other things to try (not tested yet)
## Kernel hardening
    # Turn on execshield
    kernel.exec-shield=1
    kernel.randomize_va_space=1
 
    # IP Spoofing protection
    net.ipv4.conf.all.rp_filter = 1
    net.ipv4.conf.default.rp_filter = 1
    
    # Ignore ICMP broadcast requests
    net.ipv4.icmp_echo_ignore_broadcasts = 1
    
    # Disable source packet routing
    net.ipv4.conf.all.accept_source_route = 0
    net.ipv6.conf.all.accept_source_route = 0
    net.ipv4.conf.default.accept_source_route = 0
    net.ipv6.conf.default.accept_source_route = 0
    
    # Ignore send redirects
    net.ipv4.conf.all.send_redirects = 0
    net.ipv4.conf.default.send_redirects = 0

    # Block SYN attacks
    net.ipv4.tcp_syncookies = 1
    net.ipv4.tcp_max_syn_backlog = 2048
    net.ipv4.tcp_synack_retries = 2
    net.ipv4.tcp_syn_retries = 5

    # Disable IP packet forwarding
    net.ipv4.ip_forward
    
    # Log Martians
    net.ipv4.conf.all.log_martians = 1
    net.ipv4.icmp_ignore_bogus_error_responses = 1

    # Ignore ICMP redirects
    net.ipv4.conf.all.accept_redirects = 0
    net.ipv6.conf.all.accept_redirects = 0
    net.ipv4.conf.default.accept_redirects = 0 
    net.ipv6.conf.default.accept_redirects = 0
    
    # Ignore Directed pings
    net.ipv4.icmp_echo_ignore_all = 1

Then run: `sudo sysctl -p`
## Prevent IP spoofing in /etc/host.conf
    grep -qF 'multi on' && sed 's/multi/nospoof/' || echo 'nospoof on' >> /etc/host.conf
## Find world-writable files
    find /dir -xdev -type d \( -perm -0002 -a ! -perm -1000 \) -print
## Find no-user files
    find /dir -xdev \( -nouser -o -nogroup \) -print
## Disable USBs
    echo 'install usb-storage /bin/true' >> /etc/modprobe.d/disable-usb-storage.conf
## Disable Firewire/Thunderbolt
    echo "blacklist firewire-core" >> /etc/modprobe.d/firewire.conf
    echo "blacklist thunderbolt" >> /etc/modprobe.d/thunderbolt.conf
## fail2ban
Blocks IPs with too many login attempts
    sudo apt-get install fail2ban
    sudo systemctl restart fail2ban.service
## Find rootkits, backdoors, etc.
    sudo apt-get install chkrootkit rkhunter
    sudo chkrootkit
    sudo rkhunter --update
    sudo rkhunter --check

## credit
* https://gist.github.com/bobpaw/a0b6828a5cfa31cfe9007b711a36082f
