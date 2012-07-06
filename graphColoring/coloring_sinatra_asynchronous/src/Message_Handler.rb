#!/usr/bin/env ruby

########################################################################
## @autor : Flavien Bailly					      ##
## date   : June 2012						      ##
##								      ##
## This is the Message Handler Block for ABT graph coloring algorithm ##
## for redis commands, see : http://redis.io/commands 		      ##
##								      ##
## This code is run trough "config.ru". Here is a sample 	      ##
## $ ruby config.ru portnumber name LKSport 	(3 parameters)	      ##
##	-> portnumber 	: integer > 1024			      ##
## 	-> name		: char or string (different from other nodes) ##
##	-> LKSport	: Local Knowledge Storage port number. Need   ##
##			  a redis-server running on this port 	      ##
##								      ##
## Then you can see stuff on - http://localhost:4567/stuff -	      ##
## where 4567 is your portnumber used and stuff is uri defined in get ##
## fonctions described bellow.					      ##
########################################################################

require 'rubygems'
require 'sinatra'
require 'json'
require 'net/http'
require './nogood.rb'
require 'redis'

class Comnode < Sinatra::Base

	#redis object - link with Local Knowledge Storage
	redis=Redis.new(:port => ARGV[2])	
	#Local Knowledge Storage block SETUP	#node attributes :
	redis.set("name",ARGV[1])		#name
	redis.set("portnum",ARGV[0])		#port number
	redis.set("color",1)			#colour initialisation
	redis.set("nb_color",3)			#number of colour possible
	redis.set("nb_neighbors",0)		#number of neighbors
	
	#Show node colour on http://localhost:portnumber/color
	get '/color' do	
		redis.get("color")
	end

	#Show node name on http://localhost:portnumber/name
	get '/name' do
		redis.get("name")
	end
	
	#The following function has to be used on 1 node,
	#it allows to start ABT graph coloring algorithm.
	get '/start' do
		redis.publish("update","check_agent_view")
		"There are such things"#tribute to Sinatra
	end
		
	#Show node neighbors on http://localhost:portnumber/neighbor
	get '/neighbor' do
		str=Array.new
		(redis.hkeys("neighbors")).each do |node|
			str.push(node)
		end
		str
	end
		
	#Show node agentview on http://localhost:portnumber/agentview
	get '/agentview' do
		str=Array.new
		(redis.hkeys("agentview")).each do |node|
			str.push(node)
		end
		str
	end

	#This URI is made for add neighbor easily
	#getting http://localhost:portnumber/neighbor/add/A/2345
	#add the node "A" running on "2345" portnumber to my neighbors array
	get '/neighbor/add/:name/:port' do
		redis.hset("neighbors",params[:name],params[:port])
		redis.incr("nb_neighbors")
		redis.hset("agentview",params[:name],1)
		redirect '/neighbor'
	end
	
	#This block starts when Message Handler receives ok? message
	#ok? message are made with HTTP post on "/message/ok"
	# 2 parameters :
	# 	-> ":sender" : name of sender node
	# 	-> ":value"  : value (colour) of sender node
	post '/message/ok' do
		if(redis.hexists("agentview",params[:sender]))
			redis.hset("agentview",params[:sender],params[:value])
			puts "#{params[:value]}"
		end
		redis.publish("update","check_agent_view")#publication
		"OK"
	end
	
	#This block strart when Message Handler receives nogood message
	#nogood message are made with HTTP post on "/message/nogood"
	# 2 parameters :
	# 	-> ":nogood_json" : Nogood object serialized as JSON object
	# 	-> ":sender" : name of sender node
	post '/message/nogood' do
		redis.rpush("nogood",params[:nogood_json])
		redis.rpush("nogood_sender",params[:sender]	)
		redis.publish("update","new_nogood")#publication
		"OK"
	end
end
