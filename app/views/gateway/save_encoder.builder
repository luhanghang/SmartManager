xml.instruct!

unless @errors.empty?
	xml.Errors do
		@errors.each do |error|
			xml.Error(:msg => error)
		end
	end
else
	e_fields = {}
	Encoder.column_names.each do |e_field|
  		e_fields[e_field] = @encoder[e_field]
	end
	xml.Encoder(e_fields)
end