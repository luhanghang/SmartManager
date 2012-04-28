xml.instruct!
xml.UserGroup :id => @g.id, :name => @g.name do
  xml.Users do
    @g.users.each do |u|
      xml.User :id => u.id do
      	xml.id u.id
        xml.account u.account
        xml.passwd u.passwd
        xml.realname u.realname
      end
    end
  end
  SpotGroup.tree_xml_no_empty(xml, @sgs, @g.spots) if @sgs
  SpotGroup.tree_xml_no_empty(xml, @sg_root, @g.spots)
end