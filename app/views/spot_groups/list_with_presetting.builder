xml.instruct!
xml.Groups do
if @user_id && @user_id != ''
	SpotGroup.tree_xml_with_presetting(xml, @gs, @spots, @local) if @gs
	SpotGroup.tree_xml_with_presetting(xml, @group, @spots, @local)
end
end