# AbLab 03 - users
In this lab we will learn about users and groups in Ubuntu 22.04. This lab will work in most older versions of Ubuntu and Debian.

# Requirements
1. lab01
1. Get used to keeping notes!
   1. Copy your commands
   1. Write down usernames and passwords (ideally use a password manager like KeePass)

## hints
1. Open a terminal `Ctrl+Alt+t`

# GUI view of users
1. Open `settings` then `users`
1. Add a new user `qwert` password `shiny-Appl3` as `Standard` type
   1. Note what happens with just a password of `apple`, `applesauce`, `123456789`
1. Add a new user `admen` password `jellfish_SABER/3998`

# Where is all the user information stored
As files
## User info
1. `cat /etc/passwd`
1. `grep -i 'vagrant' /etc/passwd`
## Group info
1. `cat /etc/group`
## Passwords
   1. `cat /etc/shadow` now try sudo

# Manage users in terminal
## add a new user sharla
1. `adduser sharla` accept defaults, use the password `great_DELIGHT/773`

### other way to add user
`adduser` is just a wrapper for useradd, but makes it easier
1. `sudo useradd sharla`
1. `sudo passwd sharla`

### explore the new user
1. check in the gui for the new user
1. `su sharla`
1. `id` check who we are
1. ` cd ~` move into sharlas home directory 
1. `sudo cat /etc/shadow` ...
1. `grep -i sudo /etc/group` or `grep -i adm /etc/group` note who is admin 
1. `exit` to exit sharla's terminal session

# enable and disable interactive root account
1. `sudo passwd root` set password to `I_am-super`
1. `su -`
1. `id`
1. check the gui, is root there?
### check if root is locked
1. `sudo cat /etc/shadow | grep root` or the wrapper `sudo getent shadow root`
   1. look for `root:!...`
1. `sudo passwd -l root`
   1. now check (use up arrow until you find the previous command)
1. `exit`

# Change login chances
1. `less /etc/login.defs`
   1. `/PASS` use `n` for next
   1. `q` to exit
1. `man login.defs`
   1. `/PASS` look at the definitions
   1. `q` to exit
1. Hit it `sed -i 's/PASS_MAX_DAYS.*$/PASS_MAX_DAYS 90/;s/PASS_MIN_DAYS.*$/PASS_MIN_DAYS 10/;s/PASS_WARN_AGE.*$/PASS_WARN_AGE 7/' /etc/login.defs`
   1. PASS_MAX_DAYS 90
   1. PASS_MIN_DAYS 10
   1. PASS_WARN_AGE 7

# Update PAM settings
* References
   * [](https://www.server-world.info/en/note?os=Ubuntu_22.04&p=pam&f=1)
1. `cd /etc/pam.d`
1. `ls -lah` look at the permissions on the files

## /etc/pam.d/common-auth
Allows an account lockout policy to be set
1. `sudo less /etc/pam.d/common-auth` check out the file
   1. `/tally`
1. The line we want does not exist by default
1. `echo 'auth required pam_tally2.so deny=5 onerr=fail unlock_time=1800' >> /etc/pam.d/common-auth`
   1. `deny=5` means 5 failed logins before lockout
   1. `unlock_time=1800` means 1800 seconds (30minutes) until unlocked

## /etc/security/pwquality.conf
Where ubuntu now manages password quality, may not exist in older systems
1. `man pwquality.conf` 
   1. `ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1` what would these settings do?
   1. `q`
1. `cat /etc/security/pwquality.conf`
   1. Check over the settings

## /etc/pam.d/common-password
Used to enforce password policies
1. `sudo nano /etc/pam.d/common-password`
1. we will add `remember=5 minlen=8` to the end of the line that contains `pam_unix.so`
   1. like ` 
1. In older systems may need to install cracklib `sudo apt-get install libpam-cracklib`

One liner for older systems (no `/etc/security/pwquality.conf` file)
```sh
    sed -i 's/\(pam_unix\.so.*\)$/\1 remember=5 minlen=8/' /etc/pam.d/common-password
    sed -i 's/\(pam_cracklib\.so.*\)$/\1 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1/' /etc/pam.d/common-password
```

# check the guest account
## manually
1. `sudo nano /etc/lightdm/lightdm.conf` (may not exist) OR `sudo nano /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf`
   1. add the line `allow-guest=false`
1. `sudo restart lightdm`








