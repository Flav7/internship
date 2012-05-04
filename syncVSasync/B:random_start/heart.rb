#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'net/http'
require 'json'

if ARGV.size==0
	puts "usage : $ heart.rb myPortNum listenPortNum1 listenPortNum2 ..."
	exit(0)
end
set :port, ARGV[0]
puts "Working with #{ARGV.size-1} node(s)"
listen_ports = Array.new

ARGV[1,ARGV.size].each do |port|
	Net::HTTP.get(URI("http://localhost:"+port.to_s()+"/start"))
	if(Net::HTTP.get(URI("http://localhost:"+port.to_s())) == "cool")
		listen_ports += [port]
	else
		break
	end
end
puts listen_ports
while (listen_ports.size != 0)
	(0..listen_ports.size-1).each do |i|
		puts "Node :"+(Net::HTTP.get(URI("http://localhost:"+listen_ports[i].to_s()+"/name")))
		Net::HTTP.get(URI("http://localhost:"+listen_ports[i].to_s()+"/next"))
		if(Net::HTTP.get(URI("http://localhost:"+listen_ports[i].to_s())) == "end")
			listen_ports -= [listen_ports[i]]
			break
		end
		puts listen_ports
	end
	#sleep 1
end
puts "THE END !"

exit(0)
