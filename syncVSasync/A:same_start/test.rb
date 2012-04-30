list = [2,3,15]
while (list.size != 0)
(0..list.size-1).each do |i|
	puts "indice #{i} : #{list[i].to_s}"
	list[i] -= 1
	if(list[i] == 0)
		list -= [list[i]]
		puts "indice #{i} enlevé"
		break
	end
end
end



(0..listen_ports.size-1).each do |i|
		puts "Node :"+(Net::HTTP.get(URI("http://localhost:"+listen_ports[i].to_s()+"/name")))
		Net::HTTP.get(URI("http://localhost:"+listen_ports[i].to_s()+"/next"))
		if(Net::HTTP.get(URI("http://localhost:"+listen_ports[i].to_s())) == "end")
			listen_ports -= [listen_ports[i]]
			break
		end
		puts listen_ports
	end
