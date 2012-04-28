xml.instruct!
xml.Companies do
  @companies.each do |company|
    xml.Company(:id => company.id ,:name => company.name, :visualModes => company.visual_modes, :logo => company.logo)
  end
end