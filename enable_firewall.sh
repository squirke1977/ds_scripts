#!/bin/sh

#Script to enable the firewall - add this to a workflow - and set it to run on firstboot

#enable the OSX application firewall
defaults write /Library/Preferences/com.apple.alf globalstate -int 1

exit 0
