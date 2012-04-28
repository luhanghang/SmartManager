xml.instruct!
xml.Presettings do
  @presettings.each do |p|
    xml.Presetting :id => p.id, :name => p.name, :position => p.position, :parent => p.spot_id
  end
end