#!/bin/bash

# purpose: to remove guest access, may need to check unbuntu version?
# state: untested

echo "allow-guest=false" >> /etc/lightdm/lightdm.conf
echo "autologin-user=" >> /etc/lightdm/lightdm.conf
