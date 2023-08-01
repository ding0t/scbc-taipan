# Lab 07 - secure configuration
It is common for systems to be configured for usability vs security. When a system is exposed to higher risk of compromise, such as exposure to the internet, it must be configured with more secure options in the operating system and applications.

As always; uninstall any unnecesary appl;ication vs trying to secure them.

# Requirements
* Ubuntu 22.04 virtual machine

# Scheduled jobs
Sometimes tasks need to happen at regular intervals on a computer. These 'scheduled jobs' can be used to malicious intent, and there may be unwanted jobs on the ystem.

In Linux, Cron is a service that runs jobs at regular intervals
1. `sudo systemctl status cron.service`

## crontab - user defined jobs
A way of running scheduled tasks
1. `crontab -l`
1. `sudo crontab -l`
1. `sudo crontab -r` removes all jobs
1. `sudo ls /var/spool/cron/crontab` should be empty if all jobs purged

## cron jobs - system defined jobs
These are scripts that will run at regular intervals. They are stored in a standard directory structure.
1. `ls -lah /etc/cron*` notice the scripts
   1. Note permissions on the scripts!
1. `cat /etc/crontab` could look here for malicious scheduled jobs too

# secure configs for ssh
SSH is remote access, it is on by default. Likely will still be on in challenge.

### manual ssh lab 
_note the auto script lab is in lab08_

1. create a backup of the original config `cp /etc/ssh/sshd_config ~/sshd_config_original`
1. edit banner `sudo nano /etc/issue.net`
```sh
WARNING!
Unauthorised access is prohibited.
```
1. secure config like
```sh
# edit /etc/ssh/sshd_config
Banner /etc/issue.net
# allow only ssh2
Protocol 2
# can change default port
Port 43122

# sane defaults
LoginGraceTime 20
PermitRootLogin no
MaxAuthTries 3
PasswordAuthentication  no

# if we have only specific users that need ssh
AllowUsers <username> 
# Disconnect automatically idle sessions
ClientAliveInterval 60
ClientAliveCountMax 3

# Restart ssh with "sudo systemctl restart sshd"
```

# Secure defaults

## Check sudoers for overly permissive lines
1. `sudo visudo`
1. bad `ALL ALL=NOPASSWD: ALL` all users, all commands, no password
   1. If exists delete the line 
   1. the default editor should be nano, if you end up in vi... 

## Secure kernel defaults
The kernel has some secure defaults that may be tested

1. `sudo nano /etc/sysctl.conf`
1. `ctrl + w` look for `sysrq` uncomment and set to `kernel.sysrq=0`
1. `ctrl + w` look for `syncook` uncomment ensure value is `net.ipv4.tcp_syncookies=1` 

OR paste in the following into `/etc/sysctl.conf`

```sh
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.tcp_rfc1337 = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.icmp_echo_ignore_broadcasts = 1
icmp_ignore_bogus_error_responses = 1
net.ipv4.icmp_ratelimit = 20
net.ipv4.icmp_ratemask = 88089
kernel.sysrq=0
```
1. Check the settings `sudo sysctl -a | grep 1337` is our update in place?
1. reload using `sudo sysctl --system`
   1. test `sudo sysctl -a | grep sysrq` 

## no exec on temporary file locations

1. `sudo mount -l | grep /dev/shm `
` sudo nano /etc/fstab`
   1. `none     /dev/shm     tmpfs     ro,noexec,nosuid,nodev     0     0`
1. `sudo mount -o remount /dev/shm`
1. Edit `/etc/fstab` and add `noexec,ro` options to the `/dev/shm` mount
   1. test as above to check permissions

# References

## system configs
* [ubuntu specific sysctl.conf settings](https://wiki.ubuntu.com/ImprovedNetworking/KernelSecuritySettings)
* [sysrq](https://www.debian.org/doc/manuals/securing-debian-manual/restrict-sysrq.it.html)
* [whole heap of settings](https://tldp.org/HOWTO/Adv-Routing-HOWTO/lartc.kernel.obscure.html)
* [using syxsctl](https://www.cyberciti.biz/faq/reload-sysctl-conf-on-linux-using-sysctl/)

## shm
* [stricter defualts](https://help.ubuntu.com/community/StricterDefaults)

## sudo 
link to good sudoers

## ssh
* [ssh](https://www.redhat.com/sysadmin/eight-ways-secure-ssh)

