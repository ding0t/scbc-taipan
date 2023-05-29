#

# Setup

## Create the base VM from iso
1. [Base guide](https://developer.hashicorp.com/vagrant/docs/boxes/base)
1. [Virtualbox specific](https://developer.hashicorp.com/vagrant/docs/providers/virtualbox/boxes)

* Minimal RAM
* Disable Audio and USB
* install with user vagrant:vagrant

## In VM configure required Virtualbox settings
```bash 
# edit /etc/apt/sources.list to remove cdrom
# buld headers foir linux additons dependancies
sudo apt install -y linux-headers-$(uname -r) build-essential dkms
# install guest additions
sudo sh /media/VBoxGuestAdditions/VBoxLinuxAdditions.run
sudo umount /media/VBoxGuestAdditions
sudo shutdown -r now
```

## In VM configure required OS settings
```bash
# ensure passwordless sudo
echo "vagrant ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
# install ssh server
sudo apt update
sudo apt install -y openssh-server 
sudo systemctl status ssh 
sudo ufw allow 22/tcp 
# prevent dns lookups
echo "UseDNS no" >> /etc/ssh/sshd_config
# /etc/default/ssh add -u0 option
# set up ssh
chmod 0700 ~/.ssh
wget -O ~/.ssh/authorized_keys https://raw.githubusercontent.com/hashicorp/vagrant/main/keys/vagrant.pub
chmod 0600 ~/.ssh/authorized_keys
# clean the history
history -c
sudo shutdown now
```

* add home page to firefox
* 

## Package the box
```bash
cd /path
mkdir /path/box
vagrant package --base ubuntu_2204_scbc_taipan
```

## add the box as a user
```bash
mkdir /path/to/vagrant-projects/ubuntu-2204-taipan
cd /path/to/vagrant-projects/ubuntu-2204-taipan
vagrant box add ubuntu-2204-taipan Z:/vagrant-projects/ubuntu-2204-taipan/package.box
vagrant init ubuntu-2204-taipan
vagrant up
```

