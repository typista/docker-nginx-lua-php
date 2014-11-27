#!/bin/bash
# mount:/var/www
LOCALTIME=/etc/localtime
if [ ! -L $LOCALTIME ]; then
	rm $LOCALTIME
	ln -s /usr/share/zoneinfo/Asia/Tokyo $LOCALTIME
fi

HOSTNAME=`hostname`
ROOT=/var/www/$HOSTNAME
HTML=$ROOT/html
if [ ! -e $HTML ]; then
	mkdir -p $HTML
fi
chown -R nginx: $ROOT

# mount:/var/log/nginx
LOG=/var/log/nginx/$HOSTNAME
if [ ! -e $LOG ]; then
	mkdir -p $LOG
fi
NGINX_CONF=/usr/local/nginx/conf/nginx.conf
ISDEFAULT=`grep $HOSTNAME $NGINX_CONF | wc -l`
if [ -f /root/nginx.conf ]; then
	mv /root/nginx.conf $NGINX_CONF
fi
if [ $ISDEFAULT -eq 0 ]; then
	sed -ri "s/__HOSTNAME__/$HOSTNAME/g" $NGINX_CONF
fi
chown -R nginx: $LOG

PHP_INI=/etc/php.ini
sed -ri "s/^;date.timezone =.*/date.timezone = \"Asia\/Tokyo\"/g" $PHP_INI

crontab /root/crontab.txt

/etc/init.d/php-fpm start
/etc/init.d/nginx start
/etc/init.d/crond start
/usr/bin/tail -f /dev/null
