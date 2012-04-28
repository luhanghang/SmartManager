class PollingScheme < ActiveRecord::Base
  has_many :polling_scheme_items, :dependent => :destroy
  belongs_to :user
end
