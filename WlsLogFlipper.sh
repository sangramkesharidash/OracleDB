#!/bin/ksh
###########################################################################
# Created by : Sangram Keshari Dash
# Version    : 2.0
# Script : WlsLogFlipper
# Usage 1 without pattern : sh WlsLogFlipper.sh
# Usage 2 with Pattern : sh WlsLogFlipper.sh *
# Usage 3 with Pattern : sh WlsLogFlipper.sh *SOA* *.log
###########################################################################

rm /tmp/wlslogs.out
file="/tmp/wlslogs.out"

if [$1 != '']; then echo arg dollar_one is NULL
_dollar_one=*
echo setting value for ManagedServerType to $_dollar_one
else
echo value for arg dollarone passed is $1
_dollar_one=$1
echo setting value for ManagedServerType to $_dollar_one
fi

if [$2 != '']; then echo arg dollar_two is NULL
_dollar_two=*.out
echo setting value for LogFilePattern to $_dollar_two
else
echo value for arg dollar_two passed is $2
_dollar_one=$2
echo setting value for LogFilePattern to $_dollar_two
fi

echo _________________________________________________________________________________

ls -ltr /podscratch/logs/wlslogs/FADomain/servers/$_dollar_one/logs/*.out |awk '{print $9}' > $file
echo $file
echo List Of Log Files to Flip
echo _________________________________________________________________________________
cat  $file
sleep 15
echo _________________________________________________________________________________
echo _________________________________________________________________________________

while IFS= read line
do
date
echo $line
echo _________________________________________________________________________________
tail -30 $line
echo _________________________________________________________________________________
sleep 3
done <"$file"
###########################################################################
