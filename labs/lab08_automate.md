# Lab 07 - automation

# Requirements
* Ubuntu virtual machine

# Refresher
Keep using the terminal to get used to it.
1. `ctrl + alt + t` opens a terminal
   1. Does not work in `Debian` use windows key and search `terminal` then `enter` to execute
1. Know where you are in the filesystem!
   1. `pwd` where am I now
   1. `cd /` take me to the root (like `c:\` )
   1. `cd ~` take me home
1. Filesystem contents and permissions
   1. `ls  -lah`
1. How to use a tool
   1. `man` use man for tools and some config files
1. Some tools have different options; there is some overlap, but not all are the same; eg how to search can be different.
1. If you download something, pay attention to where you downloaded it to
   1. use `find` if it is totally lost
1. To execute from PWD `./my_script.sh`
1. To execute from absolute path `/home/user/scripts/my_script.sh`

# Permissions
Permissions are for:
1. owner - the main user account that owns a file
1. group - the group that the file belongs to; eg if is a user is a member of the group, they have these permissions.
1. others - any other user on the system

Permissions are:
1. read (r) - can view the content of the file
1. write (w) - can modify, inlcuding delete
1. execute (x) - can run the program/script

## Examples 
`
-rw-r----- 1 shadow 1190 Jun 20 16:38 /etc/shadow
`

## set user and group id
set user id (suid) and set group id (sgid) is a way of forcing a file executed by others to execute as the owner. What if `root` owns the file?

1. Finding suid  for root `find / -user root -perm -4000 -exec ls -ldb {} \; > suid.txt`
1. Finding sgid for root `find / -user root -perm -2000 -exec ls -ldb {} \; > sgid.txt`

_Note there are legitimate suid and sgid applications, the ones to look out for are custom ones_

# automation intro
Many of the checks and settings can be put into a script to do the work. But:
1. You must check the script to see what it is doing
1. Remove things in scripts you dont want

## shell scripting
The terminal we have been using supports execution of a script; that is a prescribed way of getting, creating and using data and programs. In fact many things that execute, such as startup programs, are shell scripts.

Some key points:
1. It is (generally) a human readable text file. This makes it easier to figure out what it does
1. It can be created/edited with a text editor
1. It can be used to call other built in tools
1. It acts on the behalf of the permissions it was invoked with. SO if you need sudo to restart a service, you will need to call your script with sudo for that to work.
1. If you dont want a line to execute; comment that line out using `#` at the start of the line

## example sutomating the update of ssh
SSH needs some secure defaults, lets script this one..
1.  [go to](../fightclub/scripts/ssh_config.sh)
1. download the raw file
1. `chmod +x ssh_config.sh` make the file executable
1. `sudo ./ssh_config.sh` done!

What did the script do?
1. `man ssh_config`
1. `cat /etc/ssh/sshd_config`
1. `sudo ss -tlpn` where is 22 now?

