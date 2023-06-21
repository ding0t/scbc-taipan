# About
In this lab we learn how to protecting the system

Practice:
1. firewalls (gui and terminal using ufw)
1. anti-virus (purpose, gui and terminal)
1. secure defaults (sysctl sane defaults/reccomendations)

and discuss:
1. know thy system (eliminate the unecesary)
1. audit (location, application settings, improving)

# Requirements
Virtual machine running ubuntu 22.04

# Firewall

## Why do we need a firewall?
To control connections coming in and out of the system. 

## excercise
1. Remember the check for what is listening? `sudo ss -tlpn`?
   1. What do the switches do `man ss`?
   1. Run the command 
1. Lets look at current terminals open with the OS (see reference section)
   1. `w` how many sessions are there?
   1. `tty` note the number
1. `ssh vagrant@localhost` 
   1. `w` how many sessions now? Are they different?
   1. `tty` note the number
   1. `exit` and then `w`
1. If you are game ssh with a friend
   1. `ip a` under enp0s3 look for your IPv4 address like inet x.x.x.x (like 10.0.1.3)
   1. ssh to your neighbours IP `ssh vagrant@10.x.x.x`
      1. accept the key, and use the default password
      1. `w` and `ip a` check you are on a different host
      1. `DISPLAY=:0 notify-send "hello friend!"` pop up a message!
      1. `exit` to leave  

## Uncomplicated Firewall (ufw)
Debian since 10 and Ubuntu use the newer `nftables` firewall vs the original `iptables` under the hood.

## Installing UFW
Both can use `ufw` or uncomplicated firewall to manage the firewall. It is installed by default in Ubuntu, but will need to be installed on Debian. `sudo apt install ufw`
1. UFW has a GUI tool, but will need to be installed `sudo apt install gufw`
1. `man ufw` check the man pages

 ## Initial config
 1. `less /etc/dafault/ufw` look for IPV6 `/IPV6` check it says `yes`
    1. If not `sudo nano /etc/default/ufw` and add the line `ctrl+x and y to save`

 ## Getting UFW on
 1. `sudo ufw status` what is the current state?
 1. `sudo ufw enable` turn it on
    1. `sudo ufw status` is it on?
    1. `sudo systemctl status ufw` what does systemctl say
1. ` sudo ufw show listening` handy alternative to `ss` so you can get a quick idea of what you may need to firewall

## What rules are there?
1. `sudo ufw status` none?
1. Make sure UFW logs `sudo ufw logging on`

### get some strong defaults (this will break listening services!)
1. `sudo ufw default allow outgoing`
1. `sudo ufw default deny incoming`

### allow ssh in
1. ALLOW `sudo ufw allow ssh` or `sudo ufw allow 22/tcp` or whatever port/proto you need to open
   1. Note the addition  of v4 and v6 rules
   1. `sudo ufw status numbered` addition of keyword numbered, what happens without it?
1. DENY `sudo ufw deny ssh`
   1. `sudo 
1. LIMIT  We want to change the rule `sudo ufw limit ssh/tcp comment 'Rate limit for openssh server'` six or more connections in last 30 seconds (IPv4 only)
   1. `sudo ufw status numbered`
   1. `sudo ufw delete 1`

## Not working as expected - check the logs!
Sometiome  the rules block too much, or dont work, use the logs to troubleshoot
1. `sudo tail -f /var/log/ufw.log` tail grabs teh last few lines, f follows, `q` exits

## Other commands
1. Reset, reload

# Anti-virus
Is software that looks for a set of known malware using file based sigantures. In this lab we will find some malwares! 

## Get some 'malz'
1. `cd ~` change to our home directory
1. `wget https://secure.eicar.org/eicar.com.txt` grab a malware test file

## Installing
1. `sudo apt install -y clamav clamav-daemon clamtk`
1. `sudo systemctl stop clamav-freshclam` stop clam so we can force a signature update (otherwise `sudo systemctl stop clamav-freshclam`)
1. `sudo freshclam`
1. `sudo systemctl start clamav-freshclam`
1. `man clamscan` waht command do we need to only show infected vs all files, scan recursively, use heuristic, log?
1. `clamscan -i ~` results?
1. How would we scan `/var/www/html/` recusrively?

## GUI
1. `sudo apt install -y clamtk` we have already installed it
1. Start up clamtk
1. Run a scan on the file (it may say it has frozen, but it has not...)
1. Check settings 
   1. scan recursinvely, use heuristic, check for updates

# Audit
1. `sudo apt install -y auditd && auditctl` <check>

# Secure defaults

## Check sudoers for overly permissive lines
1. `sudo visudo`
1. bad `ALL\s+ALL\s*=\s*NOPASSWD\s*:\s*ALL` all users, all commands, no password
   1. If exists delete the line 
   1. the default editor should be nano, if you end up in vi... 

## Secure kernel defaults
The kernel has some secure defaults that may be tested

1. `sudo nano /etc/sysctl.conf`
1. `ctrl + w` look for `sysrq` uncomment and set to `kernel.sysrq=0`
1. `ctrl + w` look for `syncook` uncomment ensure value is `net.ipv4.tcp_syncookies=1` 

OR paste in the following into `/etc/sysctl.conf`

```sh
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.tcp_rfc1337 = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.icmp_echo_ignore_broadcasts = 1
icmp_ignore_bogus_error_responses = 1
net.ipv4.icmp_ratelimit = 20
net.ipv4.icmp_ratemask = 88089
kernel.sysrq=0
```
1. Check the settings `sudo sysctl -a | grep 1337` is our update in place?
1. reload using `sudo sysctl --system`
   1. test `sudo sysctl -a | grep sysrq` 

## Secure SSH defaults

## no exec on temporary file locations

1. `sudo mount -l | grep /dev/shm `
` sudo nano /etc/fstab`
   1. `none     /dev/shm     tmpfs     ro,noexec,nosuid,nodev     0     0`
1. `sudo mount -o remount /dev/shm`
1. Edit `/etc/fstab` and add `noexec,ro` options to the `/dev/shm` mount
   1. test as above to check permissions

# References

* [pty vs tty](https://www.baeldung.com/linux/pty-vs-tty)
* [configuring ufw](https://www.cyberciti.biz/faq/how-to-configure-firewall-with-ufw-on-ubuntu-20-04-lts/)
* [installing and using clam av](https://linuxhint.com/install_clamav_ubuntu/)
* [more clam av guides](https://wiki.archlinux.org/title/ClamAV)

## system configs
* [ubuntu specific sysctl.conf settings](https://wiki.ubuntu.com/ImprovedNetworking/KernelSecuritySettings)
* [sysrq](https://www.debian.org/doc/manuals/securing-debian-manual/restrict-sysrq.it.html)
* [whole heap of settings](https://tldp.org/HOWTO/Adv-Routing-HOWTO/lartc.kernel.obscure.html)
* [using syxsctl](https://www.cyberciti.biz/faq/reload-sysctl-conf-on-linux-using-sysctl/)

## shm
* [stricter defualts](https://help.ubuntu.com/community/StricterDefaults)

## sudo 
link to good sudoers

