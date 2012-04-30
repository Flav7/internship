#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require "pstore"

if ARGV.size <= 1
	puts "Missing parameters \n"
	puts "usage $ node.rb (s|a)mode (int)portNum (int)nodeID (int)start\n"
	exit(0)
end

class Metric
	attr_reader :description, :list, :size
	
	#Create an object
	def initialize(description,list=Array.new,size=0)
		@description=description
		@list=list
		@size=size
		file=File.new("#{ARGV[3]}/metric:#{@description}_node:#{ARGV[2]}_mode:#{ARGV[0]}","a")
		file.close
	end

	#Add value
	def addValue(value)
		time = Time.now#.strftime("%F_%T")
		@list+=[[time,value]]
		@size+=1
		file=File.new("#{ARGV[3]}/metric:#{@description}_node:#{ARGV[2]}_mode:#{ARGV[0]}","a")
		if File.zero?(file)
			file.puts("#{value}\n")
		else
			file.puts("#{value}\n")
		end
		file.close
	end
	
	#to string
	def to_s
		puts "Metric : #{@description}\n"
		(0..size).each {|i| puts "#{@list[i]}\n"}
		puts "Size : #{@size}\n"
	end
	
end

#Newton raphson step by step
def sbs_NR(exp,num,step,prec)
	res = Float(step)
	res = res - (((res**exp) - num)/(exp*(res**(exp-1))))
	if((res**exp - num) < prec)
		return 0
	else
		return res
		puts res
	end
end

#synchronous mode
def sync()
	puts "sync mode"
	$m1 = Metric.new("f(x)=x**7-77_start:#{ARGV[3]}")
	$m1.addValue(ARGV[3].to_i)
end

#asynchronous mode
def async()
	puts "async mode"
	m1 = Metric.new("f(x)=x**7-77_start:#{ARGV[3]}")
	m1.addValue(ARGV[3].to_i)
	th = Thread.new do
		while (m1.list.last[1] != 0)
			m1.addValue(sbs_NR(7,77,m1.list.last[1],0.000000001))
			puts m1.list.last[1].to_s
		end
	end
end

# main
set :port, ARGV[1]
str = "cool"
get '/' do
	str
end

get'/name'do
	ARGV[2]
end

get '/start' do
	case ARGV[0]
		when "s"
			sync()
		when "a"
			async()
		else
			"unknow mode"
	end
end

get'/next' do
	if(ARGV[0] != "s" || $m1.list.last[1] == 0)
		str="end"
	else
		$m1.addValue(sbs_NR(7,77,$m1.list.last[1],0.000000001))
	end
	redirect '/'
end



