# Lab 04 - how things run (execute)
In this lab we learn how to
1. List running processes
1. List active (listening) network connections
1. Operating system updates
   1. Settings
   1. Update now
1. Manage applications
   1. Using APT
   1. Using Snap
1. Managing services    
   1. List services and show service status
   1. Control a service

# Requirements
Virtual machine running ubuntu 22.04

# APT applications package manager
APT is the standard Ubunu/Debian software manager. It manages Operating System and application updates.

## Check the update settings in the GUI
1. Open `Software & Applications` in the GUI
   1. Check the `Updates` tab

## APT Update the system
1. GUI open `Software Updater`
1. Terminal; get the latest software list from the sources `sudo apt update` or `sudo apt-get update` if no `apt`
1. Terminal; upgradse the software to the latest `sudo apt upgrade -y`
   1. As one `sudo apt update && sudo apt-get upgrade -y`

## APT Package manager
1. Look at the sources of software here `cat /etc/apt/sources.list`
   1. Extra sources can be defined, or location moved

## APT what is installed
1. `sudo apt list --installed` lists all installed packages
   1. notice the difference
   1. `sudo apt list --installed | grep -i 'nmap'` not found? why?

## APT Install 
1. `sudo apt update` updates all the lists before looking for new software
1. ` apt search nmap` to find a package
1. `sudo apt install nmap` to install a package
1. `sudo apt list --installed | grep -i 'nmap'`

## APT remove
1. `sudo apt purge nmap` removes all config files too vs `apt remove`

# SNAP applications
Snap package manager is differnt to APT. It is not in all Linux distributions (not Debian)

## SNAP what is installed
Notice the differnces between snap and packages
1. Open `Ubuntu Software` in the GUI 
   1. Go to the `installed` tab
   1. Look for nmap

## SNAP install nmap
1. Open `Ubuntu Software` in the GUI`
   1. Install `nmap`

## SNAP update installed
1. `snap refresh --time` shows when snap will auto update next
   1. `snap refresh --hold` disables snap auto updates
   1. `snap refresh --unhold` re-enables snap auto updates
1. `sudo snap list`
   1. `sudo snap refresh --list` lists all packages that can be updated
   1. `sudo snap refresh` updates all snap packages immediately

## SNAP uninstall nmap
1. Open `Ubuntu Software` in the GUI`
   1. Uninstall `nmap`
1. OR `sudo snap remove <package>`

# services (what is a service, common services)
GUI not as popular for service managemnt in Ubuntu. We use terminal.

## What is running and listening
1. `sudo ps aux`
1. `sudo ss -tlpn` what is listening?

## install apache webserver
1. `sudo apt install apache2`
1. `sudo ps aux` 
1. `sudo ss -tlpn`

## show services running
1. `sudo systemctl --type=service` shows state of all services
   1. `sudo systemctl --type=service | grep -i apache` shows only if running
1. `sudo systemctl status apache2`

## show services even if not running
   1. `systemctl list-units -all | grep -i apache` shows if stopped

## control services
1. `sudo systemctl disable apache2`
   1. `sudo systemctl status apache2` what is the service doing?
   1. `sudo ss -tlpn` check for port 80 or 44
1. `sudo systemctl stop apache2`
   1. `sudo ss -tlpn` check for port 80 or 443