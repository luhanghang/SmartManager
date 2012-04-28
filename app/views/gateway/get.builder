xml.instruct!

xml.Encoders({:name => "编码器"}) do
  if @encoders
    xml.Company(:name => "联通", :id => "") do
      @encoders.each do |encoder|
        xml.Encoder({:name => encoder.name, :id => encoder.id}, :port => encoder.service_port) do
          encoder.spots.each do |spot|
            xml.Spot({:name => spot.name, :id => spot.id})
          end
        end
      end
    end
  end
  @companies.each do |company|
    xml.Company(:name => company.name, :id => company.id) do
      encoders = @gateway.encoders.find_all_by_company_id(company.id)
      encoders.each do |encoder|
        xml.Encoder({:name => encoder.name, :id => encoder.id}, :port => encoder.service_port) do
          encoder.spots.each do |spot|
            xml.Spot({:name => spot.name, :id => spot.id})
          end
        end
      end
    end
  end
end