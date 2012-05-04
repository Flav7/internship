#!/bin/bash
for (( i=47; i<=77; i++ ))
do
	mkdir 'sample'$(($i-47))
	cd 'sample'$(($i-47))
	ruby ../nodeVS.rb s 11111 1 $((RANDOM%43+35)) &
	PID1=$!
	ruby ../nodeVS.rb s 2222 2 $((RANDOM%43+35)) &
	PID2=$!
	ruby ../nodeVS.rb s 3333 3 $((RANDOM%43+35)) &
	PID3=$!
	ruby ../nodeVS.rb s 4444 4 $((RANDOM%43+35)) &
	PID4=$!
	ruby ../nodeVS.rb a 5555 5 $((RANDOM%43+35)) &
	PID5=$!
	ruby ../nodeVS.rb a 6666 6 $((RANDOM%43+35)) &
	PID6=$!
	ruby ../nodeVS.rb a 7777 7 $((RANDOM%43+35)) &
	PID7=$!
	ruby ../nodeVS.rb a 8888 8 $((RANDOM%43+35)) &
	PID8=$!
	#sleep 10
	until .././script_test_nodes.sh 11111 2222 3333 4444 5555 6666 7777 8888
	do
		sleep 2
	done
	until ruby ../heart.rb 9999 11111 2222 3333 4444 5555 6666 7777 8888
	do
		echo 'waiting for the heart'
	done
	echo 'sample '$(($i-47))' done'
	kill -9 $PID1 $PID2 $PID3 $PID4 $PID5 $PID6 $PID7 $PID8
	cd ..
done 
