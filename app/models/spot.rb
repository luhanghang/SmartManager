class Spot < ActiveRecord::Base
  belongs_to :encoder 
  belongs_to :spot_group
  belongs_to :company
  has_and_belongs_to_many :user_groups
  has_many :map_spots, :dependent => :destroy
  has_many :record_schedules, :dependent => :destroy, :order => :week_day
  has_many :record_schedule_dailies, :dependent => :destroy, :order => :schedule_date
  has_many :spot_presettings, :dependent => :destroy, :order => :name
  has_many :polling_scheme_items, :dependent => :destroy
  #has_many :record_files, :dependent => :destroy
  
  #将丢失分组的监控点分组设置为根分组
  def self.adjust_parent()
    root = SpotGroup.find_by_parent_id(0)
    self.find(:all).each do |spot|
      root.spots << spot unless spot.spot_group
    end
  end

  def create_presetting(presetting)
    p = SpotPresetting.new(presetting)
    p.position = find_valid_position
    self.spot_presettings << p
    return p
  end

  def url
    gateway = encoder.gateway
    return "sip:#{global_id}@#{gateway.address}:#{gateway.port}"
  end

  def find_valid_position
    position = {}
    self.spot_presettings.each do |p|
      position[p.position] = 1
    end
    for i in 1..128
      return i unless position[i]   
    end
  end
end
