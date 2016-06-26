#! /bin/sh

# Move the NIM provided .profile files
mv /home/root.profile /.profile
mv /home/user.profile /etc/security/.profile

# Set up file systems adn VGs
chfs -a size=10G /tmp
mkvg -S -y datavg hdisk1
crfs -v jfs2 -g datavg -m /software -a size=49G -A yes
crfs -v jfs2 -g datavg -m /u01 -a size=30G -A yes
chps -s 448 hd6
chfs -a size=+25M /usr
nfso -p -o nfs_use_reserved_ports=1

# Configure system devices
mkdev -l iocp0
chdev -l iocp0 -a autoconfig='Available'
tcpdump -d host 0
chdev -l sys0 -a ncargs=1024 -a maxuproc=16384

# Confifgure network attributes
no -p -o tcp_ephemeral_low=9000
no -p -o tcp_ephemeral_high=65500
no -p -o udp_ephemeral_low=9000
no -p -o udp_ephemeral_high=65500

# Create users and groups
mkgroup id=202 oinstall
mkgrouop id=203 dba
mkgroup id=204 oper
mkgroup id=205 asmdba
mkgroup id=206 asmadmin
mkgroup id=207 asmoper

mkuser -a admin='false' pgrp='system' id=12 bmurphy
mkuser -a admin='false' pgrp='system' id=13 neilkirk
mkuser -a admin='false' pgrp='system' id=14 ateixeir
mkuser -a admin='false' pgrp='system' id=15 ebsgold
mkuser -a admin='false' pgrp='system' id=16 zhasan
mkuser -a admin='false' pgrp='oinstall' groups='oper,dba,asmdba' id=16 oracle
mkuser -a admin='false' pgrp='oinstall' groups='dba,asmadmin,asmdba' id=17 grid

chuser "core=-1" "data=-1" "fsize=-1" "rss=-1" "stack=-1" "cpu=-1" "nofiles=65536" bmurphy
chuser "core=-1" "data=-1" "fsize=-1" "rss=-1" "stack=-1" "cpu=-1" "nofiles=65536" zhasan
chuser "core=-1" "data=-1" "fsize=-1" "rss=-1" "stack=-1" "cpu=-1" "nofiles=65536" neilkirk
chuser "core=-1" "data=-1" "fsize=-1" "rss=-1" "stack=-1" "cpu=-1" "nofiles=65536" ateixeir
chuser "core=-1" "data=-1" "fsize=-1" "rss=-1" "stack=-1" "cpu=-1" "nofiles=65536" oracle
chuser "data_hard=-1" "data=-1" "fsize=-1" "rss=-1" "stack=-1" "cpu=-1" "nofiles=-1" root
chuser "data_hard=-1" "data=-1" "fsize=-1" "rss=-1" "stack=-1" "cpu=-1" "nofiles=-1" grid

# Set up PATH to include access to linkxlC
export PATH=/usr/vac/bin:/usr/vacpp/bin:$PATH

# Configure VNC
mkdir /.vnc
mv /home/xstartup /.vnc/
chmod 744 /.vnc/xstartup
mkdir ~/.dt
mkdir ~/.dt/types
cp /usr/dt/appconfig/types/C/* ~/.dt/types/ 
/usr/dt/bin/dtconfig -e
vncserver -geometry 1440x900 -depth 15
