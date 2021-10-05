#!/bin/ksh
###########################################################################
# Created by  : Sangram Keshari Dash
# Version     : 2.0 - 05 OCT 2021
# Description :skdcli (dcli Manual) : This script is inspired from dcli in Exadata
#              You can run one command on all cluster nodes
# Usage  1    :  sh skdcli.sh "ps -ef|grep smon"
# Usage  2    :  sh skdcli.sh "free -g"
# Usage  3    :  sh skdcli.sh "du -sh /u01"
# Usage  3    :  clear

###########################################################################

#echo dollar one is $1
outputfile="/tmp/cluster_hosts.txt"

GRIDBINPATH=`ps -ef|grep cssdagent|grep bin|awk '{print $8}'`
#echo $GRIDBINPATH
#echo $GRIDBINPATH|  sed 's|\(.*\)/.*|\1|'
GRIDBIN=`echo $GRIDBINPATH|  sed 's|\(.*\)/.*|\1|'`
echo $GRIDBIN

$GRIDBIN/olsnodes -n |awk '{print $1}' > $outputfile
echo ###########################################################################
echo CLUSTER HOSTS ::
cat $outputfile
echo ###########################################################################

while IFS= read line
do

#output=`ssh -n $line $1`
#echo $output

echo HOST_NAME:::: $line
echo ___________________
ssh -n $line $1

sleep 1
done <"$outputfile"