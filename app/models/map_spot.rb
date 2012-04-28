class MapSpot < ActiveRecord::Base
  belongs_to :map
  belongs_to :spot
end
