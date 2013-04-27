class UserGroup < ActiveRecord::Base
  has_many :users, :dependent => :destroy
  belongs_to :role
  belongs_to :company
  has_and_belongs_to_many :spots,:order => :name
  #"convert(name USING gbk) COLLATE gbk_chinese_ci desc"
  has_and_belongs_to_many :privileges
  
  ADMIN = 2

  @@g = nil

  def self.ungrouped
    unless @@g
      @@g = self.new
      @@g.id = 0
      @@g.name = "未分组"
      @@g.users = User.ungrouped_users
    end
    return @@g
  end

  def is_admin?
    return self == UserGroup.find(:first)
  end
end
