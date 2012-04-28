xml.instruct!
xml.Groups do
if(@gs)
	SpotGroup.tree_xml_with_presetting(xml, @gs, @spots, @local)
end
SpotGroup.tree_xml_with_presetting(xml, @group, @spots, @local)
end