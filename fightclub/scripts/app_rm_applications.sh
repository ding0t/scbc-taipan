#!/usr/bin/env bash
#
# ABOUT
# These functions remove applications
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
	johnny 
	hive 
	burp 
	cainandable 
	myheritage
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
	Freeciv 
	zenmap)
    for i in "${A_TOOLS[@]}"; do
        apt purge -y "${i}"
    done
	apt autoremove -y
	write_log_entry "${logpath}" "${0}"
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
	write_log_entry "${logpath}" "${0}"
}



