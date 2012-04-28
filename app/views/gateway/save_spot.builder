xml.instruct!

unless @errors.empty?
	xml.Errors do
		@errors.each do |error|
			xml.Error(:msg => error)
		end
	end
else
	s_fields = {}
	Spot.column_names.each do |s_field|
  		s_fields[s_field] = @spot[s_field]
	end
	xml.Spot(s_fields)
end