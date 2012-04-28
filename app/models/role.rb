class Role < ActiveRecord::Base
  has_many :user_groups
  has_and_belongs_to_many :privileges
end
