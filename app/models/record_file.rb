class RecordFile < ActiveRecord::Base
  default_scope :order => 'record_date'
  belongs_to :spot
end
