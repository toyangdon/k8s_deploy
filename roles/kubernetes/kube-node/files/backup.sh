#!/bin/bash

echo "----------------------start backup etcd------"

ETCDCTL_PATH='/opt/k8s/bin/etcdctl'
ENDPOINTS="127.0.0.1:2379"
BACKUP_DIR='/data/backup/etcd'
DATE=`date +%Y%m%d-%H%M%S`
[ ! -d $BACKUP_DIR ] && mkdir -p $BACKUP_DIR
export ETCDCTL_API=3;$ETCDCTL_PATH --endpoints=$ENDPOINTS snapshot save $BACKUP_DIR/snapshot-$DATE\.db
cd $BACKUP_DIR;ls -lt $BACKUP_DIR|awk '{if(NR>11){print "rm -rf "$9}}'|sh


echo "----------------------end backup etcd------"