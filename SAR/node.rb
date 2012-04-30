#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require "pstore"

if ARGV.size <= 1
	puts "Missing parameters \n"
	puts "usage $ node.rb (s|a|r)mode (int)portNum (int)nodeID (int)num\n"
	exit(0)
end

class Metric
	attr_reader :description, :list, :size
	
	#Create an object
	def initialize(description,list=Array.new,size=0)
		@description=description
		@list=list
		@size=size
		file=File.new("metric:#{@description}_node:#{ARGV[2]}_mode:#{ARGV[0]}","a")
		file.close
	end

	#Add value
	def addValue(value)
		time = Time.now#.strftime("%F_%T")
		@list+=[[time,value]]
		@size+=1
		file=File.new("metric:#{@description}_node:#{ARGV[2]}_mode:#{ARGV[0]}","a")
		if File.zero?(file)
			file.puts("#{size-1}\t0.000000\t#{value}\n")
		else
			file.puts("#{size-1}\t#{time-self.list[0][0]}\t#{value}\n")
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

#Random number between min & max
def intervalRand(min, max)
	return rand(max-min)+min
end
 
#Newton raphson - f(x) = x**exp 
def NR(exp,num,prec)
	res = Float(num)
	while((res**exp - num) > prec)
		res = res - (((res**exp) - num)/(exp*(res**(exp-1))))
		#puts res
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

#synchronous mode
def sync()
	puts "sync mode"
	$m1 = Metric.new("f(x) = x**7 - #{ARGV[3]}")
	$m1.addValue(ARGV[3].to_i)
end

#asynchronous mode
def async()
	puts "async mode"
	m1 = Metric.new("f(x) = x**7 - #{ARGV[3]}")
	m1.addValue(ARGV[3].to_i)
	th = Thread.new do
		while (m1.list.last[1] != 0)
			m1.addValue(sbs_NR(7,ARGV[3].to_i,m1.list.last[1],0.000000001))
			puts m1.list.last[1].to_s
		end
	end
end

#realtime mode
def realT()
	puts "realtime mode"
	m1 = Metric.new("f(x) = x**7 - #{ARGV[3]}")
	m1.addValue(ARGV[3].to_i)
end

# main
set :port, ARGV[1]

get '/' do
	"haha"
end

get'/name'do
	ARGV[2]
end

get '/end' do
	"Sinatra has ended his set (crowd applauds)!"
end

get '/start' do
	case ARGV[0]
		when "s"
			sync()
		when "a"
			async()
		when "r"
			realT()
		else
			"unknow mode"
	end
end

get'/next' do
	if(ARGV[0] != "s" || $m1.list.last[1] == 0)
		redirect '/end'
	else
		$m1.addValue(sbs_NR(7,ARGV[3].to_i,$m1.list.last[1],0.000000001))
		redirect '/'
	end
end



