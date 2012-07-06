#!/usr/bin/env ruby

########################################################################
## @autor : Flavien Bailly					      ##
## date   : June 2012						      ##
##								      ##
## This file allow you to get a visualisation of your running network.##
## 								      ##
## For use it, use the following command :			      ##
## $ ruby monitor.rb PortNum Node1PortNum Node2PortNum...NodeNPortNum ##
##	-> PortNum 	: running port of this appication	      ##
##	-> nodeXPortNum : running port of each node		      ##
##								      ##
########################################################################

require 'rubygems'
require 'sinatra'
require 'net/http'
require 'json'

# This class represent an edge (link between nodes)
class Edge
	attr_reader :id, :target, :source
	
	def initialize(id,target,source)
		@id=id
		@target=target
		@source=source
	end
	
	# serialize it as a JSON document - Cytoscape Web format
	def to_json(*a)
		{
			"id" => @id , "target" => @target , "source" => @source
		}.to_json(*a)
	end
end

# This class represent a Node
class Node
	attr_reader :id, :color, :portnum

	#Create an object
	def initialize(id,color=0,portnum)
		@id=id
		@color=color
		@portnum=portnum
	end
	
	def set_color(color)
		@color=color
	end
	
	# serialize it as a JSON document - Cytoscape Web format
	def to_json(*a)
		{
			"id" => @id , "color" => @color
		}.to_json(*a)
	end
end

# This class represent all a network. It uses Node & Edge class.
class Network
	attr_reader :nodes, :edges
	
	def initialize()
		@nodes=Array.new
		@edges=Array.new
	end
	
	def add_Node(node)
		if(node.kind_of? Node)
			@nodes.push(node)
		end
	end
	
	def add_Edge(edge)
		if(edge.kind_of? Edge)
			@edges.push(edge)
		end
	end
	
	# serialize it as a JSON document - Cytoscape Web format
	def to_json(*a)
		{
			"dataSchema" => {"nodes" => [{"name" => "color" ,"type" => "string"}]},
			"data" => {"nodes" => @nodes , "edges" => @edges}
		}.to_json(*a)
	end
end

if ARGV.size==0
	puts "usage : $ ruby monitor.rb myPortNum listenPortNum1 listenPortNum2 ..."
	exit(0)
end

set :port, ARGV[0] #first parameter
set :bind, "localhost"#"192.168.0.3"
puts "Working with #{ARGV.size-1} node(s)"
$network=Network.new()

# Get all nodes
ARGV[1,ARGV.size].each do |port|
	#add node
	node=Node.new(Net::HTTP.get(URI("http://localhost:"+port.to_s()+"/name")).to_s,
					Net::HTTP.get(URI("http://localhost:"+port.to_s()+"/color")).to_s,port.to_s)
	$network.add_Node(node)
end

# Make nodes become neighbors
ARGV[1,ARGV.size].each do |port|
	node_name = Net::HTTP.get(URI("http://localhost:"+port.to_s()+"/name")).to_s
	neighbors = Net::HTTP.get(URI("http://localhost:"+port.to_s()+"/neighbor"))
	(0..(neighbors.length-1)).each do |c|
		if(node_name < neighbors[c].to_s) # this condition avoid double link
			id=node_name+"to"+neighbors[c].to_s
			edge=Edge.new(id,neighbors[c].to_s,node_name)
			$network.add_Edge(edge)
		end
	end
end

# Start visualisation on http://localhost:ARGV[0]/
get '/' do
	# set colour to each node
	$network.nodes.each do |node|
		node.set_color(Net::HTTP.get(URI("http://localhost:"+node.portnum.to_s()+"/color")).to_s)
	end
	$networ_json = $network.to_json
	erb :network #, :locals => {networ_json => network_json}
	
end

# refresh colours
get '/r' do
	$network.nodes.each do |node|
		node.set_color(Net::HTTP.get(URI("http://localhost:"+node.portnum.to_s()+"/color")).to_s)
	end
	redirect '/'
end

