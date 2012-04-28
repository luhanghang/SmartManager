class User < ActiveRecord::Base
  has_many :login_user, :dependent => :destroy
  belongs_to :user_group
  belongs_to :company
  has_one :role, :through => :user_group
  has_many :polling_schemes, :dependent => :destroy
  has_many :logs

  def self.ungrouped_users
    return self.find_all_by_user_group_id(0)
  end

  def self.ungroup_users(users)
    users.each do |u|
      u.update_attribute(:user_group_id, "0")
      u.save
    end
  end

  def privileges
    pstring = ""
    plist = self.user_group.privileges
    plist = self.role.privileges if plist.empty?
    plist.each { |p| pstring << "#{p.id}" << "," }
    return pstring
  end
end
