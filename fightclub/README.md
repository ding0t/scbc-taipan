# SCBC FightClub for Cyber Taipan
Cyber Taipan helper scripts for South Coast Baptist College

# Challenge run sheet and checklist
There is allot here, but it will give you pretty good coverage. 

OPtionally, use the fightclub script to save time. Follow the instruction [how to use](#how-to-use)

## get your admin sorted
- [ ] assign roles to each person (these can change but let others in the team know what you are doing)
   * Leader - keep track of where in the run sheet, keep records, validate work
   * Challenge system admin - the person entering the data in the challenge
   * Research and tasking - research how to solve a particular aspect, validate challenge admin has entered data/command correctly
- [ ] **keep records**

## run sheet
- [ ] CHALLENGE - first understand the challenge
    - [ ] Read the `README` on the desktop. Take notes on what it is asking. 
    - [ ] What services are required? If more than ssh, start researching what is needed to secure the service too
    - [ ] What software is not allowed?
    - [ ] What files are not allowed?
    - [ ] Are any other security policies required?
- [ ] FORENSICS - questions on desktop (good for points) [lab06](../labs/lab06_intrusion_detection_and_forensics.md)
    - [ ] Read each of the forensic questions 
    - [ ] Assign a question to a team member to research how to answer the question
    - [ ] Answer the question when ready, ensure you have the format asked for 
    - [ ] Mark it complete in your notes
- [ ] FIGHTCLUB script (optional but can make it easier)
    - [ ] install git `sudo apt install git -y`
    - [ ] `git clone` the scripts `git clone https://github.com/ding0t/scbc-taipan.git` 
- [ ] RECON - know your system [lab04](../labs/lab04_execution.md)
    - [ ] Check what is listening `sudo ss -tlpn | egrep --color=always -i '^|sshd|systemd-resolve|cupsd'` look at anything not in red. Fightclub option `RECON: listening connections`
    - [ ] Record the name any software listening that is not authorised, we will remove it later.
            look for smbd, postgres, ftp, apache2 
    - [ ] Optional advanced recon includes: 
        * `sudo crontab -l` list scheduled jobs, look for any that seem suspect
        * `systemctl --type=service` to list services
        *  `egrep -i 'sudo' /etc/group` to look for members of the sudo group that we may not have removed
        *  `sudo ps -aux` to show running processes
        *  `sudo grep -i 'install\s' /var/log/dpkg.log*` and `sudo zgrep -i 'install\s' /var/log/dpkg.log.*.gz` to look for recently installed applications. Hint, you can pipe the output to grep for a certain string of known unwanted software, other software will likely be installed around the same time. eg `sudo zgrep -i 'install\s' /var/log/dpkg.log.*.gz | egrep -B 20 -A 20 -i 'manaplus` shows 20 linse Before and After a match.
- [ ] USERS - audit users (must have for points) - [lab03](../labs/lab03_ubuntu_users.md)
    - [ ] Copy and paste the users and passwords out of the readme into your notes
    - [ ] Edit the `users.conf` file if you are using `fightclub.sh` this will enable audit and auto fix
    - [ ] If manually - go through each user using the `settings` app. You can launch from terminal using `gnome-control-center  user-accounts`
    - [ ] If using fightclub, select optioon `USERS: Audit users against config file` run an audit first, then apply the changes  by selecting 'y', then run an audit again to check it is ok
    - [ ] For users with weak passwords manually set their password using `sudo passwd <USERNAME>`
    - [ ] Lock the root account `sudo passwd -l root` or fightclub option `USERS: Lock root`
- [ ] CONFIG - set secure configs [lab07](../labs/lab07_secure_defaults.md)
    - [ ] If manual - Use the labs and research
    - [ ] Fightclub run all options starting with `CONFIG: ` except for `"CONFIG: set password and account policies" ` do that last
    - [ ] If there is a custom service you need like a web server, with php or mysql. You will need to research secure configs for them and edit their config.
    - [ ] To edit a file manually use `sudo nano <FILENAME>` , back it up first! `sudo cp <FILENAME> <FILENAME.bak>`
    - [ ] Is sudoers misconfigured. Look for the line ``
    - [ ] Are any world writable files set user id or set group id root? There will be some there by default, look for any that may be in `/home` or `/tmp`
        1. Finding suid  for root `find / -user root -perm -4000 -exec ls -ldb {} \; > suid.txt`
        1. Finding sgid for root `find / -user root -perm -2000 -exec ls -ldb {} \; > sgid.txt`
- [ ] PROTECT - install firewall and av, look for any signs of malicious activity [lab05](../labs/lab05_protecting_the_system.md)
    - [ ] Ensure the firewall is enabled, use lab or run fightclub option `PROTECT: Install Firewall and enable`
    - [ ] Configure the firewall using the utility `gufw &` your challenge README should have specific directions
    - [ ] Install and enable the anti-virus software clam av, use the lab, or fightclub option `PROTECT: Install clamAV and update signatures`
    - [ ] Run an AV scan. Use the lab or fightclub option `PROTECT: Run clamav`. Remember the gui `clamtk` takes time and may lock up, but does show results well
    - [ ] Are there any suspect cron jobs
    - [ ] If a web server is requred; check and scan the `/var/www/html/` directory for malware
- [ ] APPLICATIONS - uninstall what is not needed, update the rest (good for points) [lab04](../labs/lab04_execution.md)
    - [ ] Remove any unauthorised services listening in recon use `sudo apt purge <SERVICE NAME>` if that did not work try `apt search <SERVICE NAME>` and copy a likely looking package name and try again using that name
    - [ ] Open the start menu (windows key, click on the nine dots). Identify unwanted applications. We will remove it later. WARNING; try not to run the software!
    - [ ] Launch the `Software` gui. Identify unwanted applications. (games, unfamiliar tools). Remove it here (if not needed for forensics question)
    - [ ] If the software was not in the `software` gui, use `sudo apt purge <APP NAME>` to uninstall it
    - [ ] Run fightclub option `APPS: Purge hacker tools`
    - [ ] Check the update settings gui `software & updates` to ensure security updates are appleid. Run fightclub option `APPS: launch 'Software & Updates' GUI`
    - [ ] Lastly, run an update of all `sudo apt update && sudo apt upgrade -y` or fightclub option `APPS: Update system and applications`
- [ ] RISKIER operations last
    - [ ] Set the user password and account policies   `"CONFIG: set password and account policies" ` just in case it locks you out
- [ ] EXTRAS
    - [ ] Check the sudoers file for all users can sudo with no pasword `sudo egrep -i 'ALL\s+ALL\s*=\s*NOPASSWD\s*:\s*ALL' > /etc/sudoers` if a result returns you will need to use `sudo visudo` and edit the file (this opens the `etc/sudoers` file in nano for editing)
    - [ ] Check permissions on `ls -lah /etc/shadow /etc/passwd /etc/group` should be:
        ```
        -rw-r--r-- 1 root root   /etc/group
        -rw-r--r-- 1 root root    /etc/passwd
        -rw-r----- 1 root shadow  /etc/shadow
        ```
    - [ ] If ownership is wrong use `sudo chown <USER>:<GROUP> <FILE> ` like `sudo chown root:root /etc/group /etc/paswd`
    - [ ] If permissions are wrong use `sudo chmod `  like `sudo chmod 0640 /etc/shadow` and `sudo chmod 0644 /etc/group /etc/passwd`
- [ ] HELP! - when things go wrong
    - [ ] `dpkg` is locked - you will have to wait for a software update to complete. At worst and you have aited a while:
        * `sudo lsof /var/lib/dpkg/lock` what has the lock
        * `sudo kill -9 <PID>` get <PID> from lsof output.
        * lastly `sudo rm /var/lib/dpkg/lock` if still not unlocked
    - [ ] I cannot sudo anymore, I am locked out of my account! 
        1. `su <other admin>` switch to another admin account. You should have their credentials and can do anythin sudo from there
        1. `sudo pam_tally2 --user=<locked account sid> --reset` unlock your account
        1. `exit` return to your previous user session
    - [ ] what is that script doing? You can look in the fightclub `/scripts` directory and open up each script
    - [ ] My terminal is locked with the last command I ran. 
        * Try opening a new tab if you need that command to continue
        * If the last command opened a gui, try closing the gui
        * `ctrl + c` to interrupt the terminal
        * Close the terminal, and relaunch
    - [ ] I broke a config file!. Back up your files before you change them!
        * look for a default config online, and copy into the config
- [ ] TIPS
    - `man <COMMAND or CONFIG>` open the manual for a thing to find more detailed usage
    -  `id <USERNAME>` Find a user id
    - `sudo find / -type f -iname '*.mp3' ` use something like this to look for files from the root of the frive `/` that end with `.mp3`
    - `ls -lah <FILE or DIR>` to show permissions on a file
    - `sudo chmod o-rwx` an example of removing (r)ead (w)rite e(x)ecute from (o)thers. `+` adds permissions. owner, group, others ` u g o` are the three groups 
    - `sudo nano <FILENAME>` to edit a file owned by root
    - `/etc/passwd` is the file that contains all user accounts
    - `/etc/group` contains all groups and their members
    - `/etc/shadow` contains all users passwords in salted hash form



# How To Use the fightclub scripts
You can dowload the script as a zip and extract using `unzip`  from [https://github.com/ding0t/scbc-taipan/archive/refs/heads/main.zip](https://github.com/ding0t/scbc-taipan/archive/refs/heads/main.zip)

or by using git:

## installing
```sh
sudo apt install git -y
cd ~
git clone https://github.com/ding0t/scbc-taipan.git
``` 

## edit the users.conf file to enable the user audit
_you will find the authorised users list in the competition image readme_

NOTE: 
1. do not include spaces around the username or password
1. finish the file with a blank line

use something like:
```sh
cd ~/scbc-taipan/fightclub
gedit users.conf
```

```sh
# copy the list of users here in format
# lines with # are ignored
# use 'y' to specify a user as admin, use 'n' for otherwise
# password is the new account password
# sudo apt install pwgen
# pwgen -y 12 5 # will make 5 passwords lengthe 12 with special chars
# file must end with newline
#USERNAME,ADMIN,PASSWORD
adam_a,y,ayozai%me1Ah
lilly,n,di4Ohc#o0ohr
#
```

### run the scripts like:
```sh
cd ~/scbc-taipan/fightclub
sudo bash ./fightclub.sh
```
### look for the logs
logs are created in the same directory you ran the scripts

### caution
* FightClub has been tested, but some things may not work as expected
* Read the source and modify it if you need
* Some features are still in backlog; like enabling the firewall, and checking for malware; use the labs to do this manually yourself for now.
 
### resources
Examples of other scripts
* [cyberpatriot-checklist-ubuntu](https://github.com/Abdelgawadg/cyberpatriot-checklist-ubuntu)
* [MarKyehus/CyPatriot](https://github.com/MarKyehus/CyPatriot/blob/master/README.md)
* [BiermanM/CyberPatriot-Script](https://github.com/BiermanM/CyberPatriot-Scripts/blob/master/UbuntuScript.sh)

