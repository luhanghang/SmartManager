class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.string :name 
      t.string :visual_modes 
      t.integer :is_public, :default => 0
      t.integer :logo, :default => 0    
      t.timestamps
    end

    create_table :companies_gateways, :id => false do |t|
      t.references :gateway
      t.references :company
      t.integer :capacity, :default => 0
      t.integer :concurrency, :default => 0
    end
    
    pc = Company.new 
  	pc.name = "共享"
  	pc.visual_modes = "1"
  	pc.is_public = 1
  	pc.save
  	
  	sg = SpotGroup.new
    sg.name = pc.name
    sg.alias = pc.name
    sg.parent_id = 1
    sg.company_id = pc.id
    sg.save
  end

  def self.down
    drop_table :companies
  end
end
