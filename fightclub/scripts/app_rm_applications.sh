#!/usr/bin/env bash
#
# ABOUT
# These functions remove applications using apt
# 
# PROVIDES
# apt_purge_tools
# apt_purge_servcies


#######################################
# what
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function apt_purge_tools(){
	A_TOOLS=(netcat-* 
	aircrack-ng 
	airmon-ng 
	hydra-gtk
	john 
	burp 
	cainandable 
	wireshark 
	nmap 
	nikto 
	hashcat
	etherape 
	kismet 
	lcrack 
	ophcrack
	sl
	scanmem
	zenmap)
    for i in "${A_TOOLS[@]}"; do
        apt purge -y "${i}"
    done
	apt autoremove -y
	
}

#######################################
# what
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function apt_purge_servcies(){
	A_SERVICES=(apache2 
	dnsmasq 
	mysql-server
	nmdb 
	php5 
	postfix
	pure-ftpd 
	postgresql
	tomcat 
	tomcat6 
	telnet 
	telnet-server
	telnetd
	tightvnc-common tightvncserver 
	vnc4server 
	vncserver)
	for i in "${A_SERVICES[@]}"; do
        apt purge -y "${i}"
    done
	apt autoremove -y
	
}

#######################################
# remove games
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function apt_purge_games(){
	A_TOOLS=(freeciv)
	for i in "${A_SERVICES[@]}"; do
 	   apt purge -y "${i}"
    done
	apt autoremove -y
}

