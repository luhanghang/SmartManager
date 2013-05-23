xml.instruct!

xml.Users do
  @login_users.each do |u|
    user = u.user
    company = user.company
    group = user.user_group
    g = ""
    g = group.name if group
    c = "总部"
    c = company.name if company
    unless @company && (!company || company.id != @company)
	if Time.now - u.lasttime < 30
		lt = u.logintime
        	xml.User(:company => c, :group => g, :role => user.role.name, :realname => user.realname, :account => user.account, :login => lt.to_s[0..18])
	end	
    end
  end
end
