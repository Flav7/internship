#!/bin/bash
echo salut, je suis le script de pwnzor !
for (( i=47; i<=77; i++ ))
do
	mkdir $i
	ruby nodeVS.rb s 4444 4 $i &
	PID1=$!
	ruby nodeVS.rb a 5555 5 $i &
	PID2=$!
	sleep 3
	ruby heart.rb 7777 4444 5555
	if test $? = 0
	then
		kill -9 $PID1 $PID2
	fi
done 
