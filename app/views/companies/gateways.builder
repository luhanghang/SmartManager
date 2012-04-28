xml.instruct!
xml.Gateways do
  @gateways.each do |g|
    xml.Gateway(:id => g.gateway.id ,:name => g.gateway.name, :capacity => g.capacity, :concurrency => g.concurrency, :address => g.gateway.address)
  end
end