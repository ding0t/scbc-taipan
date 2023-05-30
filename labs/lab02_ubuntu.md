# About
In this lab we will get the Ubuntu virtual machine running, take it for a spion, and get familiar witrh the terminal.

# Requirements
1. A lab host with 
   1. virtualbox (virtualisation software)
   1. vagrant (a virtual machine manager)
1. an ubuntu `package.box` file

# Setup
We need to ensure the virtual machine is ready to go
```sh
vagrant box add ubuntu-2204-taipan Z:/vagrant-projects/ubuntu-2204-taipan/package.box
vagrant init ubuntu-2204-taipan
vagrant up
```
1. Open up `Oracle VM VirtualBox`
1. `Show` the running virtual machine

# GUI
Getting familiar with Ubuntu
1. Login vagrant:vagrant
1. Open the `file` manager, explore the file system
1. Open `settings`, explore settings
1. Open `firefox browser`, open up the labs

# CLI
Getting familiar with the CLI
1. Open the terminal `Ctrl+Alt+t`
1. Basic command `ls`
1. Command with parameter `ls --all` or short parameter `ls -a`
1. What can `ls` do? `man ls` note instructions at the bottom
1. Try these commands to get some system information:
```sh
date
whoami
hostname
lsb_release -a
```
1. Now where are we an how to move
```sh
# use pwd, and ls after each command
pwd
ls
cd / 
cd ~
cd Desktop
mkdir hello_world
cd h #tab
touch my_file
echo 'my file has content' > my_file
cat my_file
echo date >> my_file
cat my_file
find -name 'my*'
ls -lah 
rm m #tab
cd ..
```

1. Now lets get some system commands happening
```sh
top
q
ps
ps aux
ss -anup
sudo !!
```

## CLI shortcuts
1. Use tab completeion
1. Get a new tab `ctrl+Shift+t`




