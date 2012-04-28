xml.instruct!

e_fields = {}
Spot.column_names.each do |e_field|
	e_fields[e_field] = @spot[e_field]
end
xml.Spot(e_fields)