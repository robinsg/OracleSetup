#!/bin/sh
# Prereq tasks
#
# Add server name and IP address to DNS server 
# Add server name and IP address to /etc/hosts on NIM server


if [ -f /etc/niminfo ]; then
	NIMMASTER=$(awk -F'[ =]' '/NIM_MASTER_HOSTNAME/ { print $3 }' /etc/niminfo)
	HOSTNAME=$(hostname|tr [a-z] [A-Z])
	mv /etc/niminfo /etc/niminfo.$(date +"%s")
	niminit -a platform=chrp -a pif_name=en0 -a master=${NIMMASTER} -a name=${HOSTNAME} -a connect=nimsh
else
	continue
fi


##
## /etc/ntp.conf
server 10.200.60.18
broadcastclient
driftfile /etc/ntp.drift
tracefile /etc/ntp.trace

##
## /etc/ntp.drift
0.0

stopsrc -s xntpd
startsrc -s xntpd

#Uncomment in /etc/rc.tcpip