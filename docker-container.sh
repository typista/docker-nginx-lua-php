#!/bin/sh
USER=typista
if [ "$2" = "" ];then
	echo "Input parametor FQDN and HTTP-PORT"
else
	__FQDN__=$1
	__PORT__=$2
	__HOSTNAME__=`echo $__FQDN__ | sed -r "s/\./_/g"`
	FULLPATH=$(cd `dirname $0`; pwd)/`basename $0`
	DIR=`dirname $FULLPATH`
	REPO=`basename $DIR`
	REPO=`echo $REPO | sed -r "s/docker\-//g"`
	IMAGE=$USER/$REPO
	if [ "$3" != "" ];then
		IMAGE=$IMAGE:$3
	else
		VERSION=`docker images | grep "$IMAGE " | sort | tail -1 | awk '{print $2}'`
		if [ "$VERSION" != "" ];then
			IMAGE=$IMAGE:$VERSION
		fi
	fi
	docker run -d --privileged --restart=always --name="$__FQDN__" --hostname="$__HOSTNAME__" \
		-p $__PORT__:80 \
		-v /var/www/:/var/www/ \
		-v /var/log/nginx/:/var/log/nginx/ \
		-v ${PWD}/export/nginx/conf/:/usr/local/nginx/conf/ \
		-v ${PWD}/export/nginx/conf.d/:/usr/local/nginx/conf.d/ \
		-v ${PWD}/export/root/:/root/export/ \
		$IMAGE

	RESTART=./restart.sh
	touch $RESTART
	echo "docker rm -f $__FQDN__" >> $RESTART
	echo "$0 $__FQDN__ $__PORT__" >> $RESTART
	chmod +x $RESTART

	BOOT=./container/docker-boot-$__HOSTNAME__.sh
	BOOT_OFF=./container/docker-boot-off-$__HOSTNAME__.sh
	REMOVE=./container/docker-remove-$__HOSTNAME__.sh
	echo "./docker-boot.sh $__FQDN__" > $BOOT
	echo "./docker-boot-off.sh $__FQDN__" > $BOOT_OFF
	echo "docker rm -f $__FQDN__" > $REMOVE
	echo "sudo rm -rf /var/www/$__HOSTNAME__" >> $REMOVE
	chmod +x $BOOT
	chmod +x $BOOT_OFF
	chmod +x $REMOVE
	$BOOT
	NGINX_SRC=src/nginx-host.conf
	NGINX_DST=dst/$__HOSTNAME__-$__PORT__.conf
	cat $NGINX_SRC | sed -r "s/__HOSTNAME__/$__HOSTNAME__/g" > $NGINX_DST
	sed -r -i "s/__FQDN__/$__FQDN__/g" $NGINX_DST
	sed -r -i "s/__PORT__/$__PORT__/g" $NGINX_DST
fi

