class SpotGroup < ActiveRecord::Base
  has_many :spots, :order => :name
  belongs_to :company
  acts_as_tree :order => "company_id,name"

  def self.tree_xml(xml, myspots)
    group = self.find :first
    #先显示未分组的可访问的监控点
    #spots = self.my_ungrouped_spots myspots
    #spots.each do |spot|
      #xml.Spot({:name => spot.name, :parent => 0, :id => spot.id})
    #end
    self.find_all_children_xml group, xml, myspots
  end
  
  def self.tree_xml_no_empty(xml,group,myspots)
    #group = self.find :first
    #先显示未分组的可访问的监控点
    #spots = self.my_ungrouped_spots myspots
    #spots.each do |spot|
      #xml.Spot({:name => spot.name, :parent => 0, :id => spot.id})
    #end
    self.find_all_children_xml_no_empty group.company_id, group, xml, myspots
  end
  
  def self.tree_xml_short(xml,group, myspots)
    #group = self.find :first
    #先显示未分组的可访问的监控点
    #spots = self.my_ungrouped_spots myspots
    #spots.each do |spot|
      #xml.Spot({:name => spot.name, :parent => 0, :id => spot.id})
    #end
    self.find_all_children_xml_short group.company_id, group, xml, myspots
  end

  def self.tree_xml_with_presetting(xml,group, myspots,local="0")
    #group = self.find :first
    #先显示未分组的可访问的监控点
    #spots = self.my_ungrouped_spots myspots
    #spots.each do |spot|
      #xml.Spot({:name => spot.name, :parent => 0, :id => spot.id})
    #end
    self.find_all_children_xml_with_presetting group.company_id, group, xml, myspots,local
  end

  def self.find_all_children_xml(group, xml, myspots)
    group_backup = group
    #if group.has_my_spots? myspots #如果该组及其所有子组都没有任何可访问的监控点则不显示
      spots = group.my_group_spots myspots #该组可访问的监控点
      xml.Group({:name => group.name, :parent => group.parent_id, :id => group.id, :isBranch => true}) do
        unless group.children.empty? #纵向遍历
          group = group.children.first
          self.find_all_children_xml(group, xml, myspots)
        end
        spots.each do |spot|
          g = spot.encoder.gateway
          xml.Spot({:name => spot.name, :parent => spot.spot_group_id, :id => spot.id, :address => "sip:#{spot.global_id}@#{g.address}:#{g.port}"})
        end
      end
    #end
    group = group_backup #回溯
    if group.right_sibling #横向遍历
      group = group.right_sibling
      self.find_all_children_xml(group, xml, myspots)
    end
  end
  
  def self.find_all_children_xml_short(company, group, xml, myspots)
    group_backup = group
    if group.company_id == company
    #if group.has_my_spots? myspots #如果该组及其所有子组都没有任何可访问的监控点则不显示
      spots = group.my_group_spots myspots #该组可访问的监控点
      xml.Group({:name => group.name, :parent => group.parent_id, :id => group.id, :isBranch => true}) do
        unless group.children.empty? #纵向遍历
          group = group.children.first
          self.find_all_children_xml_short(company, group, xml, myspots)
        end
        spots.each do |spot|
          g = spot.encoder.gateway
          xml.Spot({:name => spot.name, :parent => spot.spot_group_id, :id => spot.id})
        end
      end
    end
    group = group_backup #回溯
    if group.right_sibling #横向遍历
      group = group.right_sibling
      self.find_all_children_xml_short(company, group, xml, myspots)
    end
  end
  
  def self.find_all_children_xml_with_presetting(company, group, xml, myspots,local="0")
    group_backup = group
    if (!company || company == '' || group.company_id == company) && (group.has_my_spots?(myspots)) #如果该组及其所有子组都没有任何可访问的监控点则不显示
      spots = group.my_group_spots myspots #该组可访问的监控点
      xml.Group({:name => group.name, :parent => group.parent_id, :id => group.id}) do
        unless group.children.empty? #纵向遍历
          group = group.children.first
          self.find_all_children_xml_with_presetting(company, group, xml, myspots,local)
        end
        spots.each do |spot|
          g = spot.encoder.gateway
          if local == "0"
          	address = g.address
          else
          	address = g.l_address
          end
          unless address.blank?
          	state = '0'
    	   	state = '1' if g.spot_states.find_by_spot(spot.global_id)
          	xml.Spot({:name => spot.name, :id => spot.id, :address => "sip:#{spot.global_id}@#{address}:3050", :state => state}) do
            	spot.spot_presettings.each do |presetting|
           	   		xml.Presetting(:name => presetting.name, :parent => spot.id, :id => presetting.id, :position => presetting.position)
            	end
          	end
          end
        end
      end
    end
    group = group_backup #回溯
    if group.right_sibling #横向遍历
      group = group.right_sibling
      self.find_all_children_xml_with_presetting(company, group, xml, myspots,local)
    end
  end

  def self.find_all_children_xml_no_empty(company, group, xml, myspots)
    group_backup = group
    if group.company_id == company && (group.has_my_spots?(myspots) || group.parent_id == 1) #如果该组及其所有子组都没有任何可访问的监控点则不显示
      spots = group.my_group_spots myspots #该组可访问的监控点
      xml.Group({:name => group.name,:isBranch => true, :id => group.id}) do
        unless group.children.empty? #纵向遍历
          group = group.children.first
          self.find_all_children_xml_no_empty(company, group, xml, myspots)
        end
        spots.each do |spot|
          g = spot.encoder.gateway
          xml.Spot({:name => spot.name, :id => spot.id})
        end
      end
    end
    group = group_backup #回溯
    if group.right_sibling #横向遍历
      group = group.right_sibling
      self.find_all_children_xml_no_empty(company, group, xml, myspots)
    end
  end

  def self.tree_data
    group = self.find_by_parent_id(0)
    list = []
    if group
      self.find_all_children(group, list, 0)
    end
    return list
  end

  def self.find_all_children(group, list, depth)
    group_backup = group
    list << { :group => group, :depth => depth }
    unless group.children.empty?
      group = group.children.first
      self.find_all_children(group, list, depth + 1)
    end
    group = group_backup
    if group.right_sibling
      group = group.right_sibling
      self.find_all_children(group, list, depth)
    end
  end

  def right_sibling
    index = index_of_siblings + 1  
    return nil if siblings.empty? || self_and_siblings.size == index
    return self_and_siblings[index]
  end

  def index_of_siblings
    return 0 if self_and_siblings.empty?
    self_and_siblings.each_with_index do |g, index|
      return index if g.id == id
    end
  end

  def self.ungrouped_spots
    return Spot.find_all_by_spot_group_id(0)
  end

  #未分组的可访问的监控点
  #myspots => 可访问的所有监控点
  def self.my_ungrouped_spots(myspots)
    my_ungrped_spots = []
    myspots.each do |spot|
      my_ungrped_spots << spot unless spot.spot_group
    end
    return my_ungrped_spots
  end

  #该组可访问的监控点
  def my_group_spots(myspots)
    my_gp_spots = []
    myspots.each do |spot|
      my_gp_spots << spot if spot.spot_group == self
    end
    return my_gp_spots
  end

  #该组是否有可访问监控点(该组及任何一个子组有可访问监控点即返回true)
  def has_my_spots?(myspots)
    spots = my_group_spots myspots
    return true unless spots.empty?
    children.each do |child|
      return true if child.has_my_spots? myspots
    end
    return false
  end
end
