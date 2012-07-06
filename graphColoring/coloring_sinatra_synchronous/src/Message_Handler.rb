#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'json'
require 'net/http'
require './nogood.rb'
require 'redis'

class Comnode < Sinatra::Base
#ARGV0 = portnum
#ARGV1 = name
	redis=Redis.new(:port => ARGV[2])
	redis.set("name",ARGV[1])
	redis.set("portnum",ARGV[0])
	redis.set("color",1)
	redis.set("nb_color",3)
	redis.set("nb_neighbors",0)
	
	get '/color' do	
		redis.get("color")
	end
	
	get '/name' do
		redis.get("name")
	end
	
	get '/end' do
		#node.the_end.to_s
		if(node.the_end == true)
			"THE END"
		else
			"WAIT"
		end
	end
	
	get '/start' do
		redis.publish("update","check_agent_view")
		"show must go on"
	end
	
	get '/test' do
		"salut"
	end
		
	get '/neighbor' do
		str=Array.new
		(redis.hkeys("neighbors")).each do |node|
			str.push(node)
			#str.push(redis.hmget("neighbors",node))
		end
		str
	end
	
	get '/agentview' do
		str=Array.new
		(redis.hkeys("agentview")).each do |node|
			str.push(node)
			#str.push(redis.hmget("neighbors",node))
		end
		str
	end
	
	get '/neighbor/add/:name/:port' do
		redis.hset("neighbors",params[:name],params[:port])
		redis.incr("nb_neighbors")
		redis.hset("agentview",params[:name],1)
		redirect '/neighbor'
	end
	
	post '/message/ok' do
		puts "start /message/ok"
		if(redis.hexists("agentview",params[:sender]))
			redis.hset("agentview",params[:sender],params[:value])
			puts "#{params[:value]}"
		end
		puts "publish /message/ok"
		redis.publish("update","check_agent_view")
		puts "END /message/ok"
		"OK"
	end
	
	post '/message/nogood' do
		#sender=params[:sender]	
		redis.rpush("nogood",params[:nogood_json])
		redis.rpush("nogood_sender",params[:sender]	)
		redis.publish("update","new_nogood")
		"OK"
	end
	
	def test(a,b)
		puts "TEEEEEEEEEEEEEEEEEEST"
		puts a
		puts b
	end
########################################################################
end
