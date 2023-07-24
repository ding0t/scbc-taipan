#!/bin/bash
#
# ABOUT
# Author: ding0t
# Install some tools

A_TOOLS=(john nmap)
A_SERVICES=(apache2 mysql-server)

function install_apt(){
    A_INSTALL=("${A_TOOLS[@]}" "${A_SERVICES[@]}")
    for i in "${A_INSTALL[@]}"; do
        apt install -y "${i}"
    done
    apt install -y "${services}"
}

function install_snap(){
    snap install "john-the-ripper"
}

function get_icap(){
    wget -q -O /var/www/html/webshell.php https://secure.eicar.org/eicar.com.txt
}

function modify_ufw(){
    ufw disable
}