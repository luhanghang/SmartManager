module MacHelper
	def to_addr(num)
		s = num.to_s(16).upcase.rjust(12,'0')
		return "#{s[0..1]}:#{s[2..3]}:#{s[4..5]}:#{s[6..7]}:#{s[8..9]}:#{s[10..11]}"
	end
end

