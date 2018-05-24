#!/bin/bash


#while script to create multiple processes
#date 01 March 2018
##################################################


#Function_Section

function function_printf {
   echo +++++++++++++++++++++++++++++++++++++++++++++
#       nohup sh w1runNmanyQ.sh > /tmp/w1runNmanyQ.sh.log &


}



if [$1 != '']; then echo arg dollarone is NULL
_dollar_one=10
echo setting value for _dollar_one to $_dollar_one as DEFAULT
else
echo value for arg dollarone passed is $1
 _dollar_one=$1
echo setting value for _dollar_one to $_dollar_one as ORIGINAL
fi

echo ______________________________________________________________
_loop_counter=0
echo value of "_loop_counter" is $_loop_counter
echo while loop strts here

while [ $_loop_counter -lt $_dollar_one ];
do

echo value of "_loop_counter" is $_loop_counter
echo value of "_dollar_one" is $_dollar_one


let _loop_counter=$_loop_counter+1

#if [$_loop_counter -eq $_dollar_one ]; then echo loop counter $_loop_counter reached max value $_dollar_one
#fi
function_printf

#nohup sh runNmanyQ.sh > /tmp/runNmanyQ.sh.log.$_loop_counter &
sqlplus perft/perft @/home/oracle/ms/scripts/runLoadGenInsertNrows.sql


done





#if [_dollar_one -gt 10 ]; then  echo arg1 is gt than 10

#else echo less than 10

#fi

