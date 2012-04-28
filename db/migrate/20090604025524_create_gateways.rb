class CreateGateways < ActiveRecord::Migration
  def self.up
    create_table :gateways do |t|
      t.integer :seq
      t.string :name
      t.string :address
      t.string :l_address
      t.integer :port
      t.integer :web_port
      t.string :apptype
      t.string :driver
      t.string :protocal   
      t.timestamps
    end
    
    create_table :spot_states do |t|
    	t.references :gateway
    	t.string :spot
    end
  end

  def self.down
    drop_table :gateways
  end
end
