# SCBC FightClub for Cyber Taipan
Cyber Taipan helper scripts for South Coast Baptist College

## How To Use
*Note: scripts can cause penalties and break images if you are not sure what it is doing*

You can dowload the script as a zip archive or by using git

### installing
```sh
sudo apt install git -y
cd ~
git clone https://github.com/ding0t/scbc-taipan.git
``` 

### edit the users.conf file to enable the user audit
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
 
# Tips for Completing the challenge
1. Priorities
   1. **keep records**
   1. Read/Do the forensic questions early
   1. Run a system update
   1. Fix user acounts 
   1. Look at update settings in gui `software & updates`
   1. Look for unauthorised software (gui) 
   1. Enumerate the system looking for things that should not be there
1. Test out the fightclub script to save time
    1. Follow the instruction [how to use](#how-to-use)



### resources
Examples of other scripts
* [MarKyehus/CyPatriot](https://github.com/MarKyehus/CyPatriot/blob/master/README.md)
* [BiermanM/CyberPatriot-Script](https://github.com/BiermanM/CyberPatriot-Scripts/blob/master/UbuntuScript.sh)

