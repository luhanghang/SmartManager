class CreateEncoders < ActiveRecord::Migration
  def self.up
    create_table :encoders do |t|
      t.integer :seq 
      t.string :name
      t.string :address
      t.integer :service_port
      t.string :ptz_protocal
      t.integer :audio_port
      t.integer :io_addr
			t.integer :connect_type
      t.integer :device 
      t.references :gateway, :default => 0
      t.references :company
      t.timestamps
    end
  end

  def self.down
    drop_table :encoders
  end
end
