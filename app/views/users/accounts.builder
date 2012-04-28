xml.instruct!
xml.Accounts do
  if @ug
    xml.Group :id => @ug.id
  end
  @users.each do |u|
    xml.Account :id => u.id, :account => u.account, :passwd => u.passwd, :realname => u.realname   
  end
end