xml.instruct!
xml.Maps do
  xml.Map(:name => "电子地图",:id => "0", :parent => "top", :thumb => Map::URI, :img => Map::URI) do
    @maps.each do |map|
      Map.tree_xml(xml, map)
    end
  end
end