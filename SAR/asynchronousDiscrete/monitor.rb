#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'net/http'
require 'json'

class Metric
	attr_reader :description, :list, :size
	
	#Create an object
	def initialize(description,list=Array.new,size=0)
		@description=description
		@list=list
		@size=size
	end

	#Add value
	def addValue(value)
		@list+=[[Time.now,value]]
		@size+=1
	end
	
	#to string
	def to_s
		puts "Metric : #{@description}\n"
		(0..(size-1)).each {|i| puts "step #{i} : #{@list[i]}\n"}
		puts "Size : #{@size}\n"
	end
	
	#to JSON tuto : http://www.skorks.com/2010/04/serializing-and-deserializing-objects-with-ruby/
	def to_json(*a)
		{
			"json_class" 	=> self.class.name,
			"data"			=> {"description" => @description, "list" => @list,"size" => @size}
		}.to_json(*a)
	end
	
	def self.json_create(o)
		new(o["data"]["description"], o["data"]["list"],o["data"]["size"])
	end
end

if ARGV.size==0
	puts "usage : $ heart.rb myPortNum listenPortNum1 listenPortNum2 ..."
	exit(0)
end
set :port, ARGV[0]
puts "Working with #{ARGV.size-1} node(s)"
str = ""

while 1
	ARGV[1,ARGV.size].each do |port|
		puts "Node :"+(Net::HTTP.get(URI("http://localhost:"+port.to_s()+"/metric/name")))
		str = Net::HTTP.get(URI("http://localhost:"+port.to_s()))
		res = JSON.parse(str)
		puts res
		Net::HTTP.get(URI("http://localhost:"+port.to_s()+"/metric/next"))
	end
	sleep 1
end
