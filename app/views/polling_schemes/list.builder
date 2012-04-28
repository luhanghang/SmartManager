xml.instruct!
xml.Schemes do
  @schemes.each do |s|
    xml.Scheme :id => s.id, :name => s.name, :interval => s.interval do
      s.polling_scheme_items.each do |i|
        item = i.item_type == 0? i.spot: i.spot_presetting
        xml.Item :id => i.id, :item_type => i.item_type, :spot => i.spot_id, :presetting => i.spot_presetting_id, :name => item.name
      end
    end
  end
end