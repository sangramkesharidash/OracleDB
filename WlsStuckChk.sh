#!/bin/bash
###########################################################################
# Created by : Sangram Keshari Dash
# StcukThreadChk  
# Version    : 1.0
# Usage : sh <script-name>.sh <managedServer-pattern>
###########################################################################

if [$1 != '']; then echo arg dollar_one is NULL

echo Re-RUN Script with patteren Example : For ALL --> * , For Pattern  *ServiceServer* *SOA*

#echo setting value for ManagedServerType to $_dollar_one
else
echo value for arg dollarone passed is $1
_dollar_one=$1
echo setting value for ManagedServerType to $_dollar_one
fi

if [$2 != '']; then echo arg dollar_two is NULL
_dollar_two=STUCK


ls -ltr /podscratch/logs/wlslogs/FADomain/servers/$_dollar_one/logs/*.out|awk '{print $9}' > /tmp/sk_log_list.txt
file=/tmp/sk_log_list.txt
while IFS= read line
do

echo $line
grep $_dollar_two $line|wc -l

sleep 1
done <"$file"
########################################################################################