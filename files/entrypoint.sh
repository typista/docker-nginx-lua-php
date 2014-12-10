#!/bin/bash
REPO=docker-nginx-lua-php
export URL_GIT=https://raw.githubusercontent.com/typista/$REPO/master/files
LOCALTIME=/etc/localtime
if [ ! -L $LOCALTIME ]; then
	rm $LOCALTIME
	ln -s /usr/share/zoneinfo/Asia/Tokyo $LOCALTIME
fi
EXEC1ST=/root/export/exec1st.sh
if [ ! -f $EXEC1ST ];then
	wget $URL_GIT/exec1st.sh -O $EXEC1ST
fi
if [ ! -x $EXEC1ST ];then
	chmod +x $EXEC1ST
fi
$EXEC1ST
/etc/init.d/crond start
/usr/bin/tail -f /dev/null
