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
########################################################################

require 'rubygems'
require './nogood'
require 'redis'
require 'net/http'
require 'json'

#Redis object : local storage knowledge - data exchange
$redis=Redis.new(:port => ARGV[0])

#Redis object : local storage knowledge - only for subscription
redisubscribe=Redis.new(:port => ARGV[0])

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
			remove_agent_view(lowest_priority_node_name)
			check_agent_view
		end
	end

	#send ok? message
	def send_ok(node_name,node_value,port_dest)
		Net::HTTP.post_form(URI("http://localhost:"+port_dest.to_s+"/message/ok"),
		{"sender" => node_name , "value" => node_value.to_s})
	end
	
	#send nogood
	def send_nogood(node_name,nogood,port_dest)
		Net::HTTP.post_form(URI("http://localhost:"+port_dest+"/message/nogood"),
		{"sender" => node_name , "nogood_json" => nogood.to_json})	
	end

#main loop : wait for a publication en "update" channel (subscribtion to redis local knowledge storage)
redisubscribe.subscribe("update") do |on|
	on.message do |channel, msg|
		case msg
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
  	end
end
