#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'json'
require "pstore"

if ARGV.size <= 1
	puts "Missing parameters \n"
	puts "usage $ node.rb (int)portNum (int)nodeID (int)num\n"
	exit(0)
end

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
		(0..size).each {|i| puts "#{@list[i]}\n"}
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

#génération d'un nombre aléatoire dans un interval donné
def intervalRand(min, max)
	res = rand(max-min)+min
	return res
 end
 
#Newton raphson - f(x) = x**exp 
def NR(exp,num,prec)
	res = Float(num)
	while((res**exp - num) > prec)
		res = res - (((res**exp) - num)/(exp*(res**(exp-1))))
		puts res
	end
	return res
end

#Newton raphson step by step
def sbs_NR(exp,num,step,prec)
	res = Float(step)
	res = res - (((res**exp) - num)/(exp*(res**(exp-1))))
	if((res**exp - num) < prec)
		return 0
	else
		return res
	end
end

# main
set :port, ARGV[0]
m1 = Metric.new("f(x) = x**7 - #{ARGV[2]}")
m1.addValue(ARGV[2].to_i)
m1_json = m1.to_json
	puts "haha"

get '/' do
	m1_json
end

get'/metric/name'do
	ARGV[1]
end

th = Thread.new do
	while (m1.list.last[1] != 0)
		m1.addValue(sbs_NR(7,ARGV[2].to_i,m1.list.last[1],0.000000001))
		m1_json = m1.to_json
		sleep 1
		puts m1.list.last[1].to_s
	end
end




