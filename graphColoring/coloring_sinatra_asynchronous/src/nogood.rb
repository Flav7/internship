#!/usr/bin/env ruby

########################################################################
## @autor : Flavien Bailly					      ##
## date   : June 2012						      ##
##								      ##
## Nogood class - Allow to creat Nogood object 			      ##
## see Algorithms for Distributed Constraint Satisfaction: A Review   ##
##								      ##
## 		              sample				      ##
##                 __________________________________                 ##
##		  |			    |	     |		      ##
##    		  |xi = 1 , xj = 2 , xk = 3 > xl != 2|		      ##
##		  |          lhs            |   rhs  |		      ##
##                |_________________________|________| 	nb_lhs = 3    ##
##								      ##
########################################################################

require 'json'

class Nogood

	attr_accessor :lhs			#left hand side
	attr_accessor :rhs			#right hand side
	attr_accessor :nb_lhs 			#number of lhs
	
	#Constructor
	def initialize(rhs=nil,lhs=nil,nb_lhs=nil)
		if (! rhs.nil?)
			@rhs=rhs
		else
			@rhs=Array.new
		end
		
		if (! lhs.nil?)
			@lhs=lhs
		else
			@lhs=Array.new
		end
		
		if (! nb_lhs.nil?)
			@nb_lhs=nb_lhs
		else
			@nb_lhs=0
		end
	end
	
	# Function to add a nogood "component" on the left hand side
	def add_lhs(node_name,node_value)
		@lhs[@nb_lhs]=[node_name,node_value]
		@nb_lhs+=1
	end
	
	# Function to show Nogood object as a string
	def to_s
		@lhs.each do |lhs|
			puts "#{lhs[0]} = #{lhs[1]} &"
		end
		puts "=> #{rhs[0]} != #{rhs[1]}"
	end
	
	# Function to serialize a Nogood object into a JSON string
	def to_json(*a)
		{
			"json_class" 	=> self.class.name,
			"data"		=> {	"rhs" => @rhs,
						"lhs" => @lhs, 
						"nb_lhs" => @nb_lhs}
		}.to_json(*a)
	end
	
	# Function to deserialize a JSON string into a Nogood object 
	# thanks to JSON.parse function
	def self.json_create(o)
		new(o["data"]["rhs"], o["data"]["lhs"],o["data"]["nb_lhs"])
	end
end
