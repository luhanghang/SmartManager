xml.instruct!

xml.Logs do
	@logs.each do |log|
		xml.Log do
			xml.time log.created_at.to_s[0..15]
			xml.username log.user_name
			xml.account log.account
			xml.operation log.operation
		end
	end	
end
