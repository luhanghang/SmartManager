xml.instruct!

e_fields = {}
Encoder.column_names.each do |e_field|
	e_fields[e_field] = @encoder[e_field]
end
xml.Encoder(e_fields)