xml.instruct!
xml.Spots do
  @spots.each do |s|
    if @local == '1'
      address = s.encoder.gateway.l_address
    else
      address =s.encoder.gateway.address
    end
    unless address.blank?
    	xml.Spot :id => s.id, :name => s.name, :url => s.global_id << "@" << address << ":3050"
    end
  end
end
