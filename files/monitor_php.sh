#!/bin/sh
BIN=/etc/init.d/php-fpm
IS_EXEC=`cat $MONITOR_PS_LIST | grep php-fpm | grep -v 'null' | grep -v 'grep'`
if [ -f $BIN -a "$IS_EXEC" = "" ];then
    $BIN start
fi

