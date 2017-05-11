#!/bin/bash

LOCK_FILE='/var/lock/rsync-lock'
REPOS="os extras updates"
CENTOS_RSYNC_HOST='rsync://mirrors.kernel.org/mirrors/centos'
CENTOS_VERSION='7.3.1611'
MIRROR_BASE='/mirrors/centos'
LOG_FILE='/var/log/yum.sync'


# only run one at a time
[ -e $LOCK_FILE ] && echo "Lockfile $LOCK_FILE already exists. Exiting" && exit 1
touch $LOCK_FILE


for i in $(echo $REPOS)
do
#echo $CENTOS_RSYNC_HOST/$CENTOS_VERSION/$i/x86_64/
#echo $MIRROR_BASE/$CENTOS_VERSION/x68_64/$i
if [ ! -e $MIRROR_BASE/$CENTOS_VERSION/x86_64/$i ] 
then
  mkdir -p $MIRROR_BASE/$CENTOS_VERSION/x86_64/$i/
fi
rsync -avSHP $CENTOS_RSYNC_HOST/$CENTOS_VERSION/$i/x86_64/ $MIRROR_BASE/$CENTOS_VERSION/x86_64/$i/ --delete
done

echo `date` "finished yum sync" >> ${LOG_FILE}

rm -f $LOCK_FILE
