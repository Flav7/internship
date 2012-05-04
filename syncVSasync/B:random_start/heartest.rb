#!/usr/bin/env ruby
require 'rubygems'
require 'net/http'

if ARGV.size==0
	puts "usage : $ heartest.rb listenPortNum1 listenPortNum2 ..."
	exit(1)
end

ARGV[0,ARGV.size].each do |port|
	urlp = URI.parse("http://127.0.0.1:"+port.to_s)
	begin
		if (Net::HTTP.start(urlp.host,urlp.port))
		puts "#{port} started\n"
		end
	rescue Exception
		STDERR.puts "Node down on #{port}"
		exit(2)
	end
end
exit(0)
