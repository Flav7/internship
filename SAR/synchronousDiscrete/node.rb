#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
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
file = File.new("metric_node_#{ARGV[2]}","w+")
file.puts m1.size.to_s+" "+m1.list.last[0].to_s+" "+m1.list.last[1].to_s
file.close

get '/' do

end

get'/metric/name'do
	ARGV[1]
end

get '/end' do
	"Sinatra has ended his set (crowd applauds)!"
end

get'/next' do
	if(m1.list.last[1] == 0)
		redirect '/end'
	else
		m1.addValue(sbs_NR(7,ARGV[2].to_i,m1.list.last[1],0.000000001))
		File.open("metric_node_#{ARGV[2]}", "w") do |file|
			file.puts m1.size.to_s+" "+m1.list.last[0].to_s+" "+m1.list.last[1].to_s
			file.close
		end
		redirect '/'
	end
end



