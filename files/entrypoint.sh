#!/bin/bash
# mount:/var/www
LOCALTIME=/etc/localtime
if [ ! -L $LOCALTIME ]; then
	rm $LOCALTIME
	ln -s /usr/share/zoneinfo/Asia/Tokyo $LOCALTIME
fi

HOSTNAME=`hostname`
FQDN=`echo $HOSTNAME | sed -r "s/_/\./g"`
ROOT=/var/www/$HOSTNAME
HTML=$ROOT/html
if [ ! -e $HTML ]; then
	mkdir -p $HTML
fi
chown -R nginx: $ROOT

# mount:/var/log/nginx
LOG=/var/log/nginx/$HOSTNAME
NGINX=/usr/local/nginx
if [ ! -e $LOG ]; then
	mkdir -p $LOG
	mkdir -p $NGINX/conf.d
fi
NGINX_CONF=/usr/local/nginx/conf/nginx.conf
ISDEFAULT=`grep $HOSTNAME $NGINX_CONF | wc -l`
if [ -f /root/nginx.conf ]; then
	mv /root/nginx.conf $NGINX_CONF
fi
if [ $ISDEFAULT -eq 0 ]; then
	sed -ri "s/__HOSTNAME__/$HOSTNAME/g" $NGINX_CONF
fi

PHP_INI=/etc/php.ini
sed -ri "s/^;date.timezone =.*/date.timezone = \"Asia\/Tokyo\"/g" $PHP_INI

SO_MONGO=/etc/php.d/30-mongo.ini
if [ ! -f $SO_MONGO ]; then
	echo "extension=mongo.so" > $SO_MONGO
fi

SO_IMAGICK=/etc/php.d/50-imagick.ini
if [ ! -f $SO_IMAGICK ]; then
	echo "extension=imagick.so" > $SO_IMAGICK
fi

MONITOR_NGINX=/root/export/monitor_nginx.sh
if [ ! -f $MONITOR_NGINX ]; then
    cp /root/monitor_nginx.sh $MONITOR_NGINX
    chmod +x $MONITOR_NGINX
fi
chown -R nginx: $LOG
crontab /root/crontab.txt
/etc/init.d/php-fpm start
/etc/init.d/nginx start
/etc/init.d/crond start
/usr/bin/tail -f /dev/null
