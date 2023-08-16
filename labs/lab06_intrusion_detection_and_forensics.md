# Lab 06 - Intrusion Detection, response and forensics
In this lab we learn some of the ways to setup a system to detect and respond to cyber intrusions.

## Cyber forensics (digital forensics)
Takes allot longer than on CSI/NCIS etrc tv shows, and generally now refers to any detailed investigation of a computing system. It should also be associated with evidence collection and handdling. But depends on the use case.

## log important events
In order to detect and respond to security incidents, the system must be pre-positioned to record information about itself. This mainly involves ensuring the sytem is logging and storing (or forwarding) log events.

## Other artefacts
It is hard not to leave a digital trace on a system. Hence on some movies you see the hacker 'thermiting' the system - physically destroying the system. Additional artefacts support investigation such as:
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

# Resources
* [auditd](https://infosecwriteups.com/building-a-siem-centralized-logging-of-all-linux-commands-with-elk-auditd-3f2e70503933)
* [threat hunting on linux - good write up with sysmon included](https://pberba.github.io/security/2021/11/22/linux-threat-hunting-for-persistence-sysmon-auditd-webshell/)

