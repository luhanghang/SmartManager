xml.instruct!
item = @item.item_type == 0? @item.spot: @item.spot_presetting
xml.Item :id => @item.id, :item_type => @item.item_type, :spot => @item.spot_id, :presetting => @item.spot_presetting_id, :name => item.name