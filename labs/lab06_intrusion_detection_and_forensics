# Intrusion Detection, response and forensics

## Cyber forensics (digital forensics)
Takes allot longer than on CSI/NCIS etrc tv shows, and generally now refers to any detailed investigation of a computing system. It should also be associated with evidence collection and handdling. But depends on the use case.

## log important events
In order to detect and respond to security incidents, the system must be pre-positioned to record information about itself. This mainly involves ensuring the sytem is logging and storing (or forwarding) log events.

## Other artefacts
It is hard not to leave a digital trace on a system. Hence on some movies you see the hacker 'thermiting' the system. Additional artefacts support investigation such as:
1. The file system, that is files stored or deleted from the hard drive
1. Memory, that is artefacts of the system running
1. Network collect; for content or fact of communications with other systems

# Lab Setup
* Virtual machine running Ubuntu 22.04

# Logging

## Default useful logs
Most logs are in /var/log/messages
* ufw
* auth
* syslog

1. `ls -lah /var/log` note some of the files and permissions
1. What about termional logs
   1. `ls -lah ~` note .bash_history by default a hidden file
   1. `less ~/.bash_history` how cool is that! `q` to exit
   1. `history | grep -i less`

## Enabling more audit with auditd
Get logging of kernel activities, like process and network connections. 
1 `sudo apt install -y auditd`
1. `man auditd` and `man auditctl`
1. `sudo auditctl -e 1` what does this do?

_Note: Now there is also sysmon for linux!_

# Forensics
Simplest is saving off files like logs and key files, look at file metadata. Very rare to come across steganography, more common to come across encryption, like password stores.

## metadata
Exiftool quite useful
1. `sudo apt install exiftool -y`
1. `exiftool eicar.com.txt` or any other file
1. `wget https://www.csiro.au/-/media/Digital-Careers/Files/CyberTaipan-Files/Modules-2020/CyberTaipan_Module1_OnlineSafety.pdf`
   1. `exiftool CyberTaipan_Module1_OnlineSafety.pdf` who wrote the docuemnt and when? Why are there so many dates?

## response
May need to find particular files
1. Can use gui search or `man find`
1. `find . -name '*.pdf' -type f` what will this do?


# other things we have missed

## Scheduled jobs
Cron is a service that runs jobs at regular intervals

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


## secure configs for ssh
SSH is remote access, it is on byu default. Likely weill still be on in challenge.

### automation intro
SSH needs some secure defaults, lets script this one..
1.  [go to](../fightclub/scripts/ssh_config.sh)
1. download the raw file
1. `chmod +x ssh_config.sh`
1. `sudo ./ssh_config.sh` done!

### manual ssh lab
What did the script do?
1. `man ssh_config`
1. `cat /etc/ssh/sshd_config`
1. `sudo ss -tlpn` wher is 22 now?

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

# Resoruces
* [auditd](https://infosecwriteups.com/building-a-siem-centralized-logging-of-all-linux-commands-with-elk-auditd-3f2e70503933)
* [threat hunting on linux - good write up with sysmon included](https://pberba.github.io/security/2021/11/22/linux-threat-hunting-for-persistence-sysmon-auditd-webshell/)
* [ssh](https://www.redhat.com/sysadmin/eight-ways-secure-ssh)
