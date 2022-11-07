#!/bin/bash

APP=$1
TIME=$2
CAP_INTERFACE=$3
SHAPE_INTERFACE=$4
TRACE=$5
URL=$6
ROUTER=$7


echo "Reading trace $TRACE"

sleep 1

for i in {1..5}
do
	while IFS= read -r line
	do
		echo $line	
		a=( $line )
		echo "Setting ${a[1]} down and ${a[2]} up"
		ssh -n $ROUTER "./shaper.sh start ${a[1]} ${a[2]} 0 0 $SHAPE_INTERFACE"
		python3 test.py $APP $TIME -i $CAP_INTERFACE -id $URL -r ${a[1]}-${a[2]} 
		sleep 1
		ssh -n $ROUTER "./shaper.sh stop"
		
	done < $TRACE
done
