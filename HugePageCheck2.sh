

#!/bin/ksh
###########################################################################
# Created by : Sangram Keshari Dash
# Version    : 0.2
# To be done more dynamic like : 401749.1
###########################################################################

#start of if else
if [$1 != '']; then 
echo "You Have not passed any argument to script"
echo "usage of script is ::::   sh scriptname.sh <grid-home-bin>"
echo "usage of script is ::::   sh scriptname.sh /u01/app/12.1.0.2/grid/bin"
_dollar_one=/u01/app/12.1.0.2/grid/bin
echo GRID HOME SELECTED :::: $_dollar_one

else
_dollar_one=$1

echo GRID HOME SELECTED :::: $_dollar_one
$_dollar_one/olsnodes -n |awk '{print $1}' > /tmp/sk_db_group.txt
fi
#end of if else



file="/tmp/sk_db_group.txt"

echo ###########################################################################
echo CLUSTER HOSTS ::
cat $file
echo ###########################################################################
#cat $memfile
echo ###########################################################################
#REPORT_HEADER=
echo '    HOST_NAME||HugePages||HugePages_Free||HugePages_Total_GB|| HugePages_Free_GB||TotalMem_GB|| UsedMem_GB|| FreeMem_GB||CacheMem_GB||TotalFree_GB'

spc10=`echo -e ' \t '`


while IFS= read line
do
#echo $line
#_v_HugePages_Total=ssh -n $line grep HugePages_Total /proc/meminfo 
# display $line or do somthing with $line

_v_HugePages_Total=`ssh -n $line grep HugePages_Total /proc/meminfo| awk '{print $2}'`
_v_HugePages_Free=`ssh -n $line grep HugePages_Free /proc/meminfo| awk '{print $2}'`



totalMem=`ssh -n $line free -g|grep Mem| awk '{print $2}'`
usedMem=`ssh -n $line free -g|grep Mem| awk '{print $3}'`
freeMem=`ssh -n $line free -g|grep Mem| awk '{print $4}'`
cacheMem=`ssh -n $line free -g|grep Mem| awk '{print $7}'`
totalFree=$(echo "${freeMem} + ${cacheMem}" | bc)


let "_v_HugePages_Total_GB=$_v_HugePages_Total*2/1024"
let "_v_HugePages_Free_GB=$_v_HugePages_Free*2/1024"

echo $line"||"   $_v_HugePages_Total""$spc10"||"$_v_HugePages_Free ""$spc10"||"$_v_HugePages_Total_GB ""$spc10"||"$_v_HugePages_Free_GB""$spc10"||"$totalMem""$spc10"||"$usedMem""$spc10"||"$freeMem""$spc10"||"$cacheMem""$spc10"||"$totalFree""$spc10
sleep 1
done <"$file"


######################################################################################################################################################################################