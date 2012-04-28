class Privilege < ActiveRecord::Base
  has_and_belongs_to_many :roles
  has_and_belongs_to_many :user_groups
end
