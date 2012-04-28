xml.instruct!
xml.Maps do
  @maps.each do |map|
    Map.tree_xml(xml, map)
  end
end