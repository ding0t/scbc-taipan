#!/bin/bash


function apt_purge_tools(){
	A_TOOLS=(netcat-* aircrack-ng airmon-ng hydra-gtk john johnny hive \
	burp cainandable myheritage wireshark nmap nikto hashcat etherape kismet lcrack ophcrack sl Freeciv zenmap)
    for i in "${A_TOOLS[@]}"; do
        apt purge -y "${i}"
    done
	apt autoremove
}

function apt_purge_servcies(){
	A_SERVICES=(apache2 dnsmasq mysql-server nmdb php5 postfix postgresql \
	tomcat tomcat6 telnet telnet-server tightvnc-common tightvncserver vnc4server vncserver)
	for i in "${A_SERVICES[@]}"; do
        apt purge -y "${i}"
    done
	apt autoremove
}

# removes snap 
function snap_remove(){
	A_SNAP_TOOLS=(nmap john-the-ripper)
    for i in "${A_SNAP_TOOLS[@]}"; do
        snap remove "${i}"
    done
}

#
function find_media_files(){
	A_MEDIA_FILES=(mp3 mov mp4 avi mpg mpeg flac m4a flv ogg mov mkv)
	A_IMAGE_FILES=(gif png jpg jpeg)
	search="*."
	dir="/home/"
	find . -name '*.mp3' -type f 
	    for i in "${A_MEDIA_FILES[@]}"; do
        find ${dir} -iname '"${search}${i}"' -type f
    done

}