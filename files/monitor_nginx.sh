#!/bin/sh
BIN=/etc/init.d/nginx
IS_EXEC=`cat $MONITOR_PS_LIST | grep nginx | grep -v 'null' | grep -v 'grep'`
if [ -f $BIN -a "$IS_EXEC" = "" ];then
    $BIN start
fi

