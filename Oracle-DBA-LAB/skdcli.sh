#!/bin/ksh
###########################################################################
# Created by  : Sangram Keshari Dash
# Version     : 1.0
# Description :skdcli (dcli Manual) : This script is inspired from dcli in Exadata
#              You can run one command on all cluster nodes
# Usage  1    :  sh skdcli.sh "ps -ef|grep smon"
# Usage  2    :  sh skdcli.sh "Free -g"
# Usage  3    :  sh skdcli.sh "du -sh /u01"
###########################################################################

echo dollar one is $1

/u01/app/12.1.0.2/grid/bin/olsnodes -n |awk '{print $1}' > /tmp/sk_db_group.txt

file="/tmp/sk_db_group.txt"

echo ###########################################################################
echo CLUSTER HOSTS ::
cat $file
echo ###########################################################################

while IFS= read line
do

#output=`ssh -n $line $1`
#echo $output

echo HOST_NAME:::: $line
echo ___________________
ssh -n $line $1



sleep 1
done <"$file"