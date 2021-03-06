#!/bin/bash -x

set -e

PROCZERO=$(hostname -i)
DIR=`dirname "$0"`

for IP in $(cat ~/boxes.txt); do
    echo "Stopping Spark Slave on $IP"

    ssh $IP "cd $SPARK_HOME && $SPARK_HOME/sbin/stop-slave.sh"
done

echo "Stopping Spark Master on $PROCZERO"
$SPARK_HOME/sbin/stop-master.sh

rm -f ${DIR}/../conf/99-zzz-automatic.conf
