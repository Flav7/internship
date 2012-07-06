#!/bin/bash

########################################################################
## @autor : Flavien Bailly					      ##
## @date   : June 2012						      ##
##								      ##
## This script makes runs for you. It uses all of others script to    ##
## repeat (50 times) runs in order to test results                    ##
########################################################################

for((j=0;j<50;j+=1))
do
	# start nodes
	./script_start.sh
	sleep 3
	# make them neighbors
	./script_network.sh
	sleep 2
	# start algorithm & store results
	ruby get_results.rb
	kill -9 `cat fikill.txt`
done

# These 2 commands count number of "1" or "2" inside "result.txt"
#grep -o 1 result.txt | wc -l
#grep -o 2 result.txt | wc -l
