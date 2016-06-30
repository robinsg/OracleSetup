#! /bin/sh

mv /home/root.profile /.profile
mv /home/user.profile /etc/security/.profile

mkdev -l iocp0
chdev -l iocp0 -P -a autoconfig='available'
tcpdump -d host 0
nfso -p -o nfs_use_reserved_ports=1

chdev -l sys0 -a ncargs=1024 -a maxuproc=16384 -a minpout=4096 -a maxpout=8193 	

no -p -o tcp_ephemeral_low=9000
no -p -o tcp_ephemeral_high=65500
no -p -o udp_ephemeral_low=9000
no -p -o udp_ephemeral_high=65500
no -p -o tcp_recvspace=65536
no -p -o tcp_sendspace=65536
no -p -o udp_recvspace=65536
no -p -o udp_sendspace=655360
no -p -o rfc1323=1
no -p -o sb_max=4194304
no -r -o ipqmaxlen=512

vmo -p -o maxperm%=90
vmo -p -o minperm%=3
vmo -p -o maxclient%=90
vmo -p -o strict_maxperm=0
vmo -p -o strict_maxclient=1
vmo -p -o lru_file_repage=0
vmo -r -o page_steal_method=1

schedo -p -D


mkuser -a admin='false' pgrp='system' id=12 bmurphy
mkuser -a admin='false' pgrp='system' id=16 zhasan
mkuser -a admin='false' pgrp='system' id=113 jhudson
mkuser -a admin='false' pgrp='system' id=114 alownds

mkgroup id=202 oinstall
mkgroup id=203 dba
mkgroup id=204 oper
mkgroup id=205 admin
mkuser -a admin='false' pgrp='dba' ebsgold
usermod -G oinstall,admin ebsgold

chuser "core=-1" "data=-1" "fsize=-1" "rss=-1" "stack=-1" "cpu=-1" "nofiles=65536" bmurphy
chuser "core=-1" "data=-1" "fsize=-1" "rss=-1" "stack=-1" "cpu=-1" "nofiles=65536" zhasan
chuser "core=-1" "data=-1" "fsize=-1" "rss=-1" "stack=-1" "cpu=-1" "nofiles=65536" jhudson
chuser "core=-1" "data=-1" "fsize=-1" "rss=-1" "stack=-1" "cpu=-1" "nofiles=65536" alownds
chuser "core=-1" "data=-1" "fsize=-1" "rss=-1" "stack=-1" "cpu=-1" "nofiles=65536" ebsgold


export PATH=/usr/vac/bin:/usr/vacpp/bin:$PATH

mkdir /.vnc
mv /home/xstartup /.vnc/
chmod 744 /.vnc/xstartup
mkdir ~/.dt
mkdir ~/.dt/types
cp /usr/dt/appconfig/types/C/* ~/.dt/types/ 
/usr/dt/bin/dtconfig -e
vncserver -geometry 1440x900 -depth 15
