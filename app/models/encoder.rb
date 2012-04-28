class Encoder < ActiveRecord::Base
	belongs_to :gateway
	belongs_to :company
	has_many :spots,  :dependent => :destroy  
end
