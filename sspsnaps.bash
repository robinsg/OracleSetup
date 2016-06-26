#! /bin/sh
#
# Program:		sspsnaps.ksh
# Author:		Glenn Robinson
# Date:			February 2016
# Description:	Read in a list of generic volumes to generate SSP snaphots for
#               The program will read in file /usr/loca/etc/sspsnaps.list
#
#				The program searches for lu's whos name start with the generic lu name and also for volumes 
#        		created by PowerVC which start "volume-" and then the lu name e.g. volume-nim_rvg
#

i=/usr/ios/cli/ioscli
CLEANONLY=${1}

if [[ $(whoami) != "root" ]]
then
        command=$(whence $0)
        # echo DEBUG I am padmin so restart $command again as the root user
        echo "$command" $1 | oem_setup_env
else
        # echo DEBUG now I am root
        if [[ ! -f /usr/local/etc/sspsnaps.list ]]
		then
			# echo DEBUG sspsnaps file not found in /usr/local/etc/sspsnaps
			exit 1
		else
			# Process each line of the input file
			while read ID
			do
				# Do some housekeeping
				for LU in $(${i} lu -list -fmt , -field LU_NAME|grep -e ^${ID} -e ^volume-${ID})
				do
					COUNT=$(${i} snapshot -list -lu ${LU}|grep ^20[1-2][0-9]|wc -l)
					if [[ ${COUNT} -gt 6 ]]
					then
						OLDEST=$(${i} snapshot -list -lu ${LU}|grep ^20[1-5][0-9]|tail -n 1)
						echo "Removing oldest snapshot ${OLDEST}"
						${i} snapshot -remove ${OLDEST} -lu ${LU}
					fi
				done
				
				if [[ ${CLEANONLY} == "N" ]]
				then
					# Now create the new snapshots
					LUNAMES=$(${i} lu -list -fmt , -field LU_NAME| grep -e ^${ID} -e ^volume-${ID} | tr '\n' ' ')
					print "Creating snaphot for volumes ${LUNAMES}"
					${i} snapshot -create -lu ${LUNAMES}
					print "Snapshot complete for volumes ${LUNAMES}"
				fi
			done </usr/local/etc/sspsnaps.list
				${i} snapshot -list
		fi
fi
exit 0


