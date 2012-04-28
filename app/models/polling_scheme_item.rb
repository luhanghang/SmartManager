class PollingSchemeItem < ActiveRecord::Base
  belongs_to :polling_scheme
  belongs_to :spot
  belongs_to :spot_presetting
end
