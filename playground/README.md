# ABOUT
Playground is for setting up some excercises to practice what we have learned in the labs


# SETUP
What is needed to get this happening...
1. You can use either debian or Ubuntu for the playground
1. When you vm is running, take a snapshot by selecting `machine` then `trake snapshot` in virtualbox
1. We need to get a set of scripts from github, this repository.
```sh
sudo apt install git
git clone https://github.com/ding0t/scbc-taipan.git
cd scbc-taipan/playground
chmod +x init_play.sh
sudo ./init_play.sh
``` 
_Note: If you did not chmod +x you will need to tell the terminal what to open the file with like:_
`sudo bash init_play.sh`

When the script has run you will get a message on terminal that the _playground is ready!_


# PLAY
Now we are ready to test our skills!

## tips
1. _make sure you take notes, use a basic text file, or a shared word document with others to practice_
1. Copy and paste commands!
1. Use tab completion
1. Try new things!


## what to check for
_there is a hacker on the system! they have made an unauthorised account, and installed some malware, and left some evidence in a file_

1. [Check user accounts](#users)
   1. Check the user should exist
   1. Check they have the right permission (admin or not)
   1. Check their password is complex enough _write it down if you change it_
1. [lock the root account](../labs/lab03_ubuntu_users.md)
1. [/etc/sudoers has been hacked, fix it](../labs/lab07_secure_defaults.md)
1. [remove hacker tools from apt](../labs/lab04_execution.md)
1. [remove hacker tools from snap if run on ubuntu](../labs/lab04_execution.md)
1. [find some malware](../labs/lab05_protecting%20_the_system.md)
   * _hint install clamav, and scan the directory /var/www_
1. [is there a firewall running?](../labs/lab05_protecting%20_the_system.md)
1. [secure the ssh config](../labs/lab07_secure_defaults.md)
1. [answer the forensics questions](#forensics-questions)


## Users
The following users are expected on the system

| USERNAME | ROLE | PASSWORD |
|---------|---------|---------|
| adam_a | admin | GOOD_slyber_886 | 
| jennyj | teachers | changeme | 
| jenny_a | admin | changemetoo | 
| henryh | student | pa$$w0rd! | 
| ingrids | student | newly_MADE_549 |


## forensics questions
1. There is an unauthorised user on the system; what file is in their home directory?
1. What was the malware file called?


# resources
* Use the labs to find some tips
* **For the bold** check out the source code that made the changes:
   * [here is the main script](./init_play.sh) 
   * [here are the scripts it 'imports'](./libs/)




