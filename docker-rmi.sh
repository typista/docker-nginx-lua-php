#!/bin/sh
USER=typista
FULLPATH=$(cd `dirname $0`; pwd)/`basename $0`
DIR=`dirname $FULLPATH`
REPO=`basename $DIR`
REPO=`echo $REPO | sed -r "s/docker\-//g"`
IMAGE=$USER/$REPO
if [ "$1" != "" ];then
    IMAGE=$IMAGE:$1
fi
docker rmi $IMAGE

