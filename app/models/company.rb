class Company < ActiveRecord::Base
  has_many :users, :dependent => :destroy
  has_many :user_groups, :dependent => :destroy
  has_and_belongs_to_many :gateways
  has_many :companies_gateways#, :dependent => :destroy
  has_many :spots,:order => :name
  has_many :spot_groups, :dependent => :destroy
  has_many :encoders
  has_many :logs
  #has_many :maps, :dependent => :destroy
  
  LOGO_URI = "/images/logos/"
  DEFAULT_LOGO = "/assets/logo.jpg"

  def self.get_logo_uri
    return Company::LOGO_URI
  end

  def logo_store_file
    return "public" << self.logo_uri
  end

  def logo_uri
    return  "#{Company.get_logo_uri}logo_#{self.id}.jpg" if self.logo == 1
    return DEFAULT_LOGO 
  end

  def save_logo(file)
    f = File.new(self.logo_store_file, "wb")
    f.write file.read
    f.close
  end

  def destroy_logo
    FileUtils.rm_rf self.logo_store_file if self.logo == 1
  end
end
