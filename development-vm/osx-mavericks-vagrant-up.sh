#!/bin/sh

# Mavericks has a problem starting virtual box due to permissions.
# This should save you a bit of hassle until the problem is fixed.

vagrant up $1 ||
sudo /Library/StartupItems/VirtualBox/VirtualBox restart &&
vagrant up $1
