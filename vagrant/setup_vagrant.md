# About
This file details how to set up a lab machine for taipan

# Prerequisites
1. Windows host
1. Approprate hardware spec...

# Setup
1. Install a provider (virtaulbox)
1. Install Vagrant
1. Copy our taipan repository to a user accessable location

## Install the provider
A provider is the virtualisation software. Virtualbox is free, and well supported by vagrant. VMWare is not free, more common in commercial deployments, and needs an additional helper to run from vagrant.

### Virtualbox as a provider
1. Install virtualbox from [here](https://www.virtualbox.org/wiki/Downloads)

## OR VMWare as a provider
1. Install vmware workstation
1. Install Vagrant [here](https://developer.hashicorp.com/vagrant/downloads)
1. Install VMWare utility [here](https://developer.hashicorp.com/vagrant/downloads/vmware)

## THEN install vagrant
1. Install vagrant from [here](https://developer.hashicorp.com/vagrant/downloads)

# Testing install
1. Run Powershell
1. run `vagrant up`

# Making a base image
* [here](https://gist.github.com/chuckg/7902165)
* `vagrant package --output vagrant-ubuntu-2204.box --base ubuntu_2204_scbc_taipan`
* `vagrant box add  ubuntu-2204-taipan vagrant-ubuntu-2204.box`
mkdir -p ~/Development/vagrant-test
cd ~/Development/vagrant-test
vagrant init vagrant-ubuntu-x.x.x-server-amd64

## SUDO
echo "vagrant ALL=NOPASSWD: ALL" >> /etc/sudoers

## SSH: Add vagrant public key to vagrant user
mkdir -m 0700 -p /home/vagrant/.ssh
chown vagrant /home/vagrant/.ssh
curl https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub >> /home/vagrant/.ssh/authorized_keys


