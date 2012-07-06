#!/usr/bin/env ruby

########################################################################
## @autor : Flavien Bailly					      ##
## @date   : June 2012						      ##
##								      ##
## This prog compare the current network running with two             ##
## possibilities known. It write the result ("1" for first version,   ##
## "2" for second and "X" if the version is false) in the file        ##
## "result.txt".						      ##
## 								      ##
########################################################################


require 'net/http'

#start algorithm
Net::HTTP.get(URI("http://localhost:2222/start"))

#wait end of algorithm
puts "sleep 10"
sleep 10

#write in file "resulst.txt"
myFile = File.open("result.txt", "a+")


if(Net::HTTP.get(URI("http://localhost:2222/color"))== "2" &&
   Net::HTTP.get(URI("http://localhost:3333/color"))== "1" &&
   Net::HTTP.get(URI("http://localhost:4444/color"))== "3" &&
   Net::HTTP.get(URI("http://localhost:5555/color"))== "1" &&
   Net::HTTP.get(URI("http://localhost:6666/color"))== "2" &&
   Net::HTTP.get(URI("http://localhost:7777/color"))== "3")
	myFile.write ("1")
else
	if(	Net::HTTP.get(URI("http://localhost:2222/color"))== "2" &&
		Net::HTTP.get(URI("http://localhost:3333/color"))== "1" &&
		Net::HTTP.get(URI("http://localhost:4444/color"))== "3" &&
		Net::HTTP.get(URI("http://localhost:5555/color"))== "2" &&
		Net::HTTP.get(URI("http://localhost:6666/color"))== "1" &&
		Net::HTTP.get(URI("http://localhost:7777/color"))== "3")
			myFile.write ("2")
	else
			myFile.write ("X")
	end
end
myFile.close

# These 2 commands count number of "1" or "2" inside "result.txt"
#grep -o 1 result.txt | wc -l
#grep -o 2 result.txt | wc -l
