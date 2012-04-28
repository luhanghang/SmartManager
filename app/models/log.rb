class Log < ActiveRecord::Base
	belongs_to :user
	belongs_to :company
	
	def self.log(user_id, operation)
		l = Log.new 
		user = User.find(user_id)
		l.operation = operation
		l.user_name = user.realname
		l.account = user.account
		#u = User.find(user.id)
		#c = Company.find(user.company.id)
		user.logs << l 
		user.company.logs << l unless user.role.alias == "su" || user.role.alias == "mo" 
	end
end
