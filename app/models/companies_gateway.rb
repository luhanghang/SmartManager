class CompaniesGateway < ActiveRecord::Base
  belongs_to :company
  belongs_to :gateway
end
