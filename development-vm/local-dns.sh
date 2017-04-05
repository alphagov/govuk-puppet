#!/bin/sh

VAGRANT_IP=`grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' Vagrantfile.local | sort | uniq`
MAC_IP=`ifconfig en1 | grep 'inet ' | cut -d: -f2 | awk '{ print $2}'`

sudo echo "Set your phone's DNS to $MAC_IP"
echo "Ctrl-c to kill this script"
sudo python ./minidns $MAC_IP &
sudo ssh -L 80:0.0.0.0:80 -i $HOME/.vagrant.d/insecure_private_key vagrant@$VAGRANT_IP -g -N
