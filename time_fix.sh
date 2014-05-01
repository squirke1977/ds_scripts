#!/bin/sh
#incredibly simple script to point the Mac being built at the local DC
#new out of box machines often have a system clock a mile out - or at least out enough 
#to prevent AD binding from working.
#obviously change the DC to your local DC

ntpdate londc01

exit 0
