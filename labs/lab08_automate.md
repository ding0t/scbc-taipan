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

## example automating the secure configuration of ssh
SSH needs some secure defaults, lets script this one..
1.  [go to](../fightclub/scripts/config_ssh.sh)
1. download the raw file
1. `chmod +x ssh_config.sh` make the file executable
1. `sudo ./ssh_config.sh` done!

What did the script do?
1. `man ssh_config`
1. `cat /etc/ssh/sshd_config`
1. `sudo ss -tlpn` where is 22 now?

## other scripts
Have a look at some of the other scripts in [fightclub](../fightclub/scripts/)

## LinPEAS
LinPEAS is a shell script to look for vulnerable system states that coule result in Privilige Escalation (PE). Not sure yet if this is allowed in the challenge as an audit tool.

1. `wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh -P /dev/shm`
1. `cd /dev/shm` go where the script is
1. `gedit linpeas.sh` observe shell scripting to the max
1. `./linpeas.sh` does not execute
1. `bash ./linpeas.sh | tee out.txt` executes because we specify bash as the executable, and the script as an argument
1. `grep -i sudo -A 3 out.txt` 


# Resources
* [Linpeas](https://github.com/carlospolop/PEASS-ng/tree/master/linPEAS)
* [bash tutorial](https://www.javatpoint.com/bash)
* [another bash scripting tutorial](https://www.linode.com/docs/guides/intro-bash-shell-scripting/)



