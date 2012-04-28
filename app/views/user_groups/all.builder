xml.instruct!
xml.UserGroups do
  #xml.UserGroup :id => @g.id, :name => @g.name
  @groups.each do |g|
  	#user_count = g.users.count
    xml.UserGroup :id => g.id, :name => g.name, :role => g.role.alias, :alias => g.role.name   
  end
end