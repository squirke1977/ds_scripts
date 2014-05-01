#!/bin/sh
###
# First Boot script - now trimmed down for DeployStudio
 



#Install grumpy applications that won't Instadmg here: - moving this into a DeployStudio "run on firstboot" workflow instead
#mine are in dmg files to get around permissions hell - hence the hdiutil attach/detach commands
#installs SEP - which doesn't play nicely with DeployStudio *even* when added to the "install on firstboot folder"
hdiutil attach /.Apps/SEP.dmg
installer -pkg /Volumes/SEP/SEP.mpkg -target /
hdiutil detach /Volumes/SEP
  
#Adds Printers - 
defaults write /Library/Preferences/com.apple.print.PrintingPrefs DefaultPaperID iso-a4  #sets A4!
#lpadmin -p 'Manchester_Printer' -E -v lpd://10.41.12.2 -P /Library/Printers/PPDs/Contents/Resources/HP\ LaserJet\ M2727\ MFP - it's knackered and not worth installing
lpadmin -p "Manchester_Main_Printer" -E -v lpd://10.91.33.30 -P /Library/Printers/PPDs/Contents/Resources/Kyocera\ FS-C2126MFP+.ppd
lpadmin -p "Hamburg_Mono_Printer" -E -v lpd://10.26.33.2 -P /Library/Printers/PPDs/Contents/Resources/HP\ LaserJet\ P2055.gz
lpadmin -p "Hamburg_Dell_Printer" -E -v lpd://10.26.33.1 -P /Library/Printers/PPDs/Contents/Resources/Dell\ 2155cdn\ Color\ MFP.gz
lpadmin -p "London_Printer01" -E -v lpd://10.9.1.30 -P /Library/Printers/PPDs/Contents/Resources/Kyocera\ TASKalfa\ 4550ci.ppd

#cp /Volumes/firstboot_pkgs/London_Printer01.ppd /etc/cups/ppd/   #adds custom PPD file for London Kyocera - enables finishing unit.

#lpadmin -p "Printer Name" -L "Printer Location" -D "Printer Description" -E -v lpd://server/printqueue -P $genericppd -o printer-is-shared=false


#Run the Apple software update command
softwareupdate -ia

#Let's try to secure things a little
pwpolicy -setglobalpolicy "requiresAlpha=1 requiresNumeric=1 minChars=4"      	#no blank passwords, and some basic complexity - local accounts


#Globally disable the Java browser plugin
./Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin/Contents/Resources/JavaControlPanelHelper -disable

#Move Cisco AnyConnect to Applications - partly for clarity - but also to break the auto-launch on login

mv /Applications/Cisco/Cisco\ AnyConnect\ Secure\ Mobility\ Client.app/ /Applications

#Enable encryption for the first user to log on - and store the details locally for now

serial_number=$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}')

fdesetup enable -defer /Users/Shared/$serial_number.plist

#Create a very basic machine log - then email it to Steve, so I know the script is done

hostname >> /tmp/sysinfo.txt
echo $serial_number >> /tmp/sysinfo.txt 
ioreg -l | grep model  >> /tmp/sysinfo.txt 

python ./Library/Scripts/ThoughtWorks/mail.py

exit 0
