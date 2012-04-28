xml.instruct!
xml.Spots do
  @spots.each do |s|
    xml.Spot(:name => s.spot.name,:id => s.spot_id, :x => s.x, :y => s.y)
  end
end