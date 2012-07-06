#!/usr/bin/env ruby

########################################################################
## @autor : Flavien Bailly					      ##
## date   : June 2012				         	      ##
##								      ##
## This is the Action Engine for ABT graph coloring algorithm.        ##
## for redis commands, see : http://redis.io/commands		      ##
##								      ##
## run it :							      ##
## $ ruby Action_Engine.rb LKSport				      ##
##	-> LKSport	: Local Knowledge Storage port number. Need   ##
##			  a redis-server running on this port	      ##
##								      ##
## More, it need an other redis-server running on default port (6379) ##
## which is heartbeat manager. You can start it with the following    ##
## command : $ redis-server					      ##
##								      ##
########################################################################

require 'rubygems'
require './nogood'
require 'redis'
require 'net/http'
require 'json'

#Redis object : local storage knowledge - data exchange
$redis=Redis.new(:port => ARGV[0])

#Redis object : Heartbeat link - Here we need a redis-server running
#on default port (6379)
redisheartbeat=Redis.new

#Message queue (FIFO)
msgQ=Array.new

#HeartBeat received - boolean
$hbreceived=false

	#find_neighbor return true if node_name is in its neighboring
	def find_neighbor(node_name)
		if($redis.hexists("neighbors",node_name))
			return true
		else
			return false
		end
	end
	
	#find_neighbor return true if node_name is in its agentview
	def	find_agent_view(node_name)
		if($redis.hexists("agentview",node_name))
			return true
		else
			return false
		end
	end
	
	#remove node_name from my agentview
	def remove_agent_view(node_name)
		$redis.hdel("agentview",node_name)
	end
	
	#update my agentview : set values to value's sender if sender exists
	def revise_agent_view(sender,value)
		if($redis.hexists("agentview",sender))
			$redis.hset("agentview",sender,value)
		end
	end
	
	#return true if node value is consistent with its agentview
	# return false if it is not
	def consistent_value
		($redis.hvals("agentview")).each do |node_color|
			if(node_color == $redis.get("color"))
				return false
			end
		end
		return true
	end
	
	#return a wich is consistent with agentview
	#return nil if it doesn't exist
	def find_value
		values=Array.new
		possible_values=Array.new
		(0..($redis.get("nb_color").to_i-1)).each do |i|
			possible_values[i]=(i+1).to_s
		end
		values=possible_values-($redis.hvals("agentview"))
		return values[0]
	end
	
	#check_agent_view function (see ABT graph coloring algorithm)
	def check_agent_view
		if(consistent_value == false)
			new_value=find_value
			if(new_value==nil)
				backtrack
			else
				$redis.set("color",new_value)
				$redis.hkeys("neighbors").each do |node|
					send_ok($redis.get("name"),$redis.get("color"),$redis.hget("neighbors",node))
				end
			end
		end
	end
	
	#backtrack function (see ABT graph coloring algorithm)
	def backtrack
		#generate a new nogood
		ng=Nogood.new([$redis.get("name"),$redis.get("color")])
		lowest_priority_node_name=" "
		$redis.hkeys("agentview").each do |node_name|
			node_value=$redis.hget("agentview",node_name)
			ng.add_lhs(node_name,node_value)
			#look for lowest priority node
				if(lowest_priority_node_name<node_name)
					lowest_priority_node_name=node_name
				end
		end
		#if nogood is "empty"
		if(ng.nb_lhs == 1 && ng.lhs[0][0] == $redis.get("name"))
			puts "*** backtrack : no solution"
			exit(0)
		else
			send_nogood($redis.get("name"),ng,$redis.hget("neighbors",lowest_priority_node_name))
			puts "*** backtrack : nogood envoye"
			remove_agent_view(lowest_priority_node_name)
			check_agent_view
		end
	end
	
	#send ok? message
	def send_ok(node_name,node_value,port_dest)
		test_hb #wait for heartbeat to process
		Net::HTTP.post_form(URI("http://localhost:"+port_dest.to_s+"/message/ok"),
		{"sender" => node_name , "value" => node_value.to_s})
	end
	
	#send nogood
	def send_nogood(node_name,nogood,port_dest)
		test_hb #wait for heartbeat to process
		Net::HTTP.post_form(URI("http://localhost:"+port_dest+"/message/nogood"),
		{"sender" => node_name , "nogood_json" => nogood.to_json})	
	end

	#test_hb waits for heatbeat	
	def test_hb
		puts "waiting for heartbeat"
		while($hbreceived != true)
			sleep 0.1
		end
		$hbreceived=false
		return true
	end

#Thread 1 : subscription to "update" channel on LKStorage redis-server
# it puts action to perform in message queue (msgQ)	
th1=Thread.new do
	redisubscribe=Redis.new(:port => ARGV[0])
	redisubscribe.subscribe("update") do |on|
		on.message do |channel,msg|
			msgQ.push([Time.now,msg])
		end
	end
end

#Thread 2 : subscription to "heartbeat" channel on heartbeat redis-server
# it puts "hbreceived" boolean to true when a publication appears on this channel
th2=Thread.new do
	redisheartbeat.subscribe("heartbeat") do |on|
		on.message do |channel, msg|
			#if hbreceived is already true
			if($hbreceived == true)
				puts "!"#nothing
			else
				$hbreceived=true
			end
		end
	end
end

#main loop : perform action if there is one in message queue. Synchronous mode is managed
# thanks to "send_ok" and "send_nogood" funtions.
while(true)
		if(msgQ.empty? == false)#if there is action to perform in message queue
			tmp=msgQ.shift
			case tmp[1]
				when "check_agent_view"
					check_agent_view	
				when "new_nogood"
					nogood=JSON.parse($redis.lpop("nogood"))
					if(find_agent_view(nogood.rhs[0]) == false)
						$redis.hset("agentview",nogood.rhs[0],nogood.rhs[1])
					end
					nogood.lhs.each do |lhs|
						if(find_agent_view(lhs[0]) == false && find_neighbor(lhs[0]) == true)
							$redis.hset("agentview",lhs[0],lhs[1])
						end
					end
					old_value=$redis.get("color")
					check_agent_view
					if(old_value==$redis.get("color"))
						send_ok($redis.get("name"),$redis.get("color"),$redis.hget("neighbors",$redis.lpop("nogood_sender")))
					end
				else
					puts "strange" #never happen if well used
			end
		else
			#puts "nothing to do - heartbeat at:#{msg}"
			#no action to perform in message queue : do nothing
		end
end
