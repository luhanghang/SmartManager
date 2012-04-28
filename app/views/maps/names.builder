xml.instruct!
xml.Names do
  Map.find(:all).each do |map|
    xml.Name(:value => map.name)
  end
end  