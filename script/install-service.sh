#!/bin/sh

CURDIR=$(pwd)
SERVICE=$1; shift;
SERVICE_PATH=$CURDIR/service/$SERVICE

if [ ! -e $SERVICE_PATH/run ] || [ ! -e $SERVICE_PATH/log/run ] ; then
    echo 'illegal service'
    exit 1
fi

mkdir /tmp/$SERVICE/log -p
ln -s $SERVICE_PATH/run /tmp/$SERVICE/
ln -s $SERVICE_PATH/log/run /tmp/$SERVICE/log/
mv /tmp/$SERVICE /service/

