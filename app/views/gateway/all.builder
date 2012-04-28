xml.instruct!

xml.gateways do
	if @gateways
    	@gateways.each do |g|
     		capacity = 0
      		concurrency = 0
      		g.companies_gateways.each do |cg|
      			capacity += cg.capacity
      			concurrency += cg.concurrency
      		end
       
      	xml.gateway do
      		xml.address(g.address)
      		xml.l_address(g.l_address)
			xml.id(g.id)
			xml.name(g.name)
			xml.port(g.port)
			xml.capacity(capacity)
			xml.concurrency(concurrency)
			xml.spots(0)
			xml.encoders(0)
      	end
    end
    else
    	@company.companies_gateways.each do |cg|
    		xml.gateway do
    			g = cg.gateway
    			xml.address(g.address)
    			xml.l_address(g.l_address)
    			xml.id(g.id)
    			xml.name(g.name)
    			xml.port(g.port)
    			xml.capacity(cg.capacity)
    			xml.concurrency(cg.concurrency)
    			xml.spots(0)
    			xml.encoders(0)
    		end
    	end	
    end
end
