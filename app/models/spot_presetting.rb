class SpotPresetting < ActiveRecord::Base
  belongs_to :spot
  has_many :polling_scheme_items, :dependent => :destroy
end
