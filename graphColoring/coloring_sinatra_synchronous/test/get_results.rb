#!/usr/bin/env ruby

########################################################################
## @autor : Flavien Bailly					      ##
## @date   : June 2012						      ##
##								      ##
## This program compare the current network running with one          ##
## possibilitie. If they are the same, it writes "TRUE" in 	      ##
## "result.txt" file, else it writes "WRONG". Normally, this 	      ##
## synchronous mode must always give the same colouring.	      ##
##								      ##
########################################################################

require 'redis'
require 'net/http'

#redis object : heart
redis=Redis.new

#start algorithm
Net::HTTP.get(URI("http://localhost:2222/start"))
sleep 1

#send a heartbeat. each one is a "step" of the algorithm.
(0..7).each do
	redis.publish("heartbeat",Time.now.to_s)
	sleep 1
end

#write results in "result.txt" file.
myFile = File.open("result.txt", "a+")


if(Net::HTTP.get(URI("http://localhost:2222/color"))== "2" &&
   Net::HTTP.get(URI("http://localhost:3333/color"))== "1" &&
   Net::HTTP.get(URI("http://localhost:4444/color"))== "3" &&
   Net::HTTP.get(URI("http://localhost:5555/color"))== "2" &&
   Net::HTTP.get(URI("http://localhost:6666/color"))== "1" &&
   Net::HTTP.get(URI("http://localhost:7777/color"))== "3")
		myFile.write ("TRUE")
else
		myFile.write ("!!!!!!!!!!!!WRONG!!!!!!!!!!!")
end
myFile.close
