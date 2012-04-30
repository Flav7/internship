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
str = ""

ARGV[1,ARGV.size].each do |port|
	Net::HTTP.get(URI("http://localhost:"+port.to_s()+"/start"))
end

while 1
	ARGV[1,ARGV.size].each do |port|
		puts "Node :"+(Net::HTTP.get(URI("http://localhost:"+port.to_s()+"/name")))
		#str = Net::HTTP.get(URI("http://localhost:"+port.to_s()))
		#res = JSON.parse(str)
		#puts res
		Net::HTTP.get(URI("http://localhost:"+port.to_s()+"/next"))
	end
	sleep 1
end
