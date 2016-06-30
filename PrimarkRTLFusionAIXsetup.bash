#! /bin/sh

mv /home/root.profile /.profile
mv /home/user.profile /etc/security/.profile

mkvg -S -y datavg hdisk1
crfs -v jfs2 -g datavg -m /software -a size=99G -A yes
chfs -a size=5G /tmp
nfso -p -o nfs_use_reserved_ports=1

mkdev -l iocp0
chdev -l iocp0 -P -a autoconfig='available'

chdev -l sys0 -a ncargs=1024 -a maxuproc=16384

no -p -o tcp_ephemeral_low=9000
no -p -o tcp_ephemeral_high=65500
no -p -o udp_ephemeral_low=9000
no -p -o udp_ephemeral_high=65500


mkuser -a admin='false' pgrp='system' id=12 bmurphy
mkuser -a admin='false' pgrp='system' id=13 neilkirk
mkuser -a admin='false' pgrp='system' id=14 ateixeir
mkuser -a admin='false' pgrp='system' id=16 zhasan

mkgroup id=202 oinstall
mkuser pgrp='oinstall' id='213' orawls
mkgroup id=203 dba
mkgroup id=204 oper
mkuser -a admin='false' pgrp='dba' ebsgold
usermod -G oinstall ebsgold

chuser "data_hard=-1" "data=-1" "fsize=-1" "rss=-1" "stack=-1" "cpu=-1" "nofiles=-1" root
chuser "core=-1" "data=-1" "fsize=-1" "rss=-1" "stack=-1" "cpu=-1" "nofiles=65536" orawls

export PATH=/usr/vac/bin:/usr/vacpp/bin:$PATH


mkdir /.vnc
mv /home/xstartup /.vnc/
chmod 744 /.vnc/xstartup
mkdir ~/.dt
mkdir ~/.dt/types
cp /usr/dt/appconfig/types/C/* ~/.dt/types/ 
/usr/dt/bin/dtconfig -e
vncserver -geometry 1440x900 -depth 15
