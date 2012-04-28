xml.instruct!
xml.Groups do
  SpotGroup.tree_xml_short(xml,@gs, @ss) if @gs 
  SpotGroup.tree_xml_short(xml,@group, @spots)
end