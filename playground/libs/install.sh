#!/bin/bash
#
# ABOUT
# Author: ding0t
# Install some tools

hacker_tools="john nmap"
services="apache2 mysql"

function install_apt(){
    apt install -y "${hacker_tools}"
    apt install -y "${services}"
}

function install_snap(){
    snap install "john-the-ripper"
}

function get_icap(){
    wget -O /var/www/html/webshell.php https://secure.eicar.org/eicar.com.txt
}