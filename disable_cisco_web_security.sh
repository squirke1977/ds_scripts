#!/bin/sh

#Script to uninstall Cisco Websecurity  - add this to a workflow - and set it to run on firstboot

#Remove the stupid Cisco WebSecurity module that we don't have a licence for, and that might cause browser issues
cd /
./opt/cisco/anyconnect/bin/websecurity_uninstall.sh

exit 0
