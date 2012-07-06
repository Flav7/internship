#!/bin/bash

########################################################################
## @autor : Flavien Bailly					      ##
## @date   : June 2012						      ##
##								      ##
## This script initialize 6 nodes.		                      ##
## At the end, PID of each processus is stores in a file (fikill.txt) ##
## So, you can kill all of them with : $ kill -9 `cat fikill.txt`     ##
##								      ##
########################################################################

cd ../src/

#######   HEART   #######
redis-server &
PIDheart=$!

#######   NODE A  #######
redis-server ../test/redis_conf/redis1.conf &
PIDrsA=$!
ruby config.ru 2222 A 2223 &
PIDmhA=$!
ruby Action_Engine.rb 2223 &
PIDaeA=$!

#######   NODE B  #######
redis-server ../test/redis_conf/redis2.conf &
PIDrsB=$!
ruby config.ru 3333 B 3334 &
PIDmhB=$!
ruby Action_Engine.rb 3334 &
PIDaeB=$!

#######   NODE C  #######
redis-server ../test/redis_conf/redis3.conf &
PIDrsC=$!
ruby config.ru 4444 C 4445 &
PIDmhC=$!
ruby Action_Engine.rb 4445 &
PIDaeC=$!

#######   NODE D  #######
redis-server ../test/redis_conf/redis4.conf &
PIDrsD=$!
ruby config.ru 5555 D 5556 &
PIDmhD=$!
ruby Action_Engine.rb 5556 &
PIDaeD=$!

#######   NODE E  #######
redis-server ../test/redis_conf/redis5.conf &
PIDrsE=$!
ruby config.ru 6666 E 6667 &
PIDmhE=$!
ruby Action_Engine.rb 6667 &
PIDaeE=$!

#######   NODE F  #######
redis-server ../test/redis_conf/redis6.conf &
PIDrsF=$!
ruby config.ru 7777 F 7778 &
PIDmhF=$!
ruby Action_Engine.rb 7778 &
PIDaeF=$!

cd ../test/
echo "$PIDheart $PIDrsA $PIDmhA $PIDaeA $PIDrsB $PIDmhB $PIDaeB $PIDrsC $PIDmhC $PIDaeC $PIDrsD $PIDmhD $PIDaeD $PIDrsE $PIDmhE $PIDaeE $PIDrsF $PIDmhF $PIDaeF"
echo "$PIDheart $PIDrsA $PIDmhA $PIDaeA $PIDrsB $PIDmhB $PIDaeB $PIDrsC $PIDmhC $PIDaeC $PIDrsD $PIDmhD $PIDaeD $PIDrsE $PIDmhE $PIDaeE $PIDrsF $PIDmhF $PIDaeF" > fikill.txt 
#kill -9 `cat fikill.txt`
