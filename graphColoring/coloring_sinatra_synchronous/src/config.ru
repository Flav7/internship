require './Message_Handler.rb'

#:port => ARGV[0]
#run Comnode
#n=Node.new("A",ARGV[0])	
Comnode.run! :host => 'localhost', :port => ARGV[0]
