#!/bin/bash
# <UDF name="USERNAME" Label="Username" />
# <UDF name="PASSWORD" Label="Password" />
# <UDF name="HOSTNAME" Label="Hostname" />

exec >/root/stackscript.log 2>&1 

# import StackScript Bash Library
source <ssinclude StackScriptID=1>

system_set_hostname $HOSTNAME

# setup user & sudo
echo "Setup users"
user_add_sudo $USERNAME $PASSWORD
ssh_disable_root

echo "updating system"
system_update
apt-get -y install software-properties-common fail2ban
goodstuff

sleep 5
echo "Firewall setup"
ufw allow 22
ufw allow 80
ufw allow 443
ufw disable
ufw enable
ufw status verbose

echo "nginx"
apt -y install nginx

echo "certbot"
add-apt-repository universe
add-apt-repository ppa:certbot/certbot
apt-get update
apt-get -y install python-certbot-nginx
echo "Restarting stuff"
restartServices

echo "done"
