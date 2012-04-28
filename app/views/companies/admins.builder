xml.instruct!
xml.Accounts do
  @accounts.each do |account|
    xml.Account(:id => account.id ,:realname => account.realname, :passwd => account.passwd, :account => account.account)
  end
end