xml.instruct!
xml.Gateways do
  @gateways.each do |g|
    xml.Gateway(:name => g.name, :address => g.address) do
    	g.companies_gateways.each do |cg|
    		spot_count = cg.company.spots.find_all_by_gateway_id(g.id).count
    		xml.Company(:name => cg.company.name, :capacity => cg.capacity, :concurrency => cg.concurrency, :spots => spot_count)
    	end
    end
  end
end