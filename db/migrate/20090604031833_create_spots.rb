class CreateSpots < ActiveRecord::Migration
  def self.up
    create_table :spots do |t|
      t.integer :seq
      t.string :name
      t.string :alias
      t.string :global_id
      t.references :encoder
      t.references :spot_group, :default => 1
      t.integer :v_encode_type
      t.integer :v_channel
      t.integer :v_com_method
      t.integer :v_src_port
      t.integer :v_protocal_type
      t.integer :v_encode_rate
      t.integer :v_resolution
      t.integer :a_encode_type
      t.integer :a_channel
      t.integer :a_com_method
      t.integer :a_src_port
      t.integer :a_protocal_type
      t.integer :a_encode_rate 
      t.references :company  
      t.timestamps
    end

    create_table :spot_groups do |t|
      t.string :name
      t.string :alias
      t.integer :parent_id, :default => 1
      t.references :company
    end

    sg = SpotGroup.new
    sg.name = "监控点分组"
    sg.parent_id = 0
    sg.save
  end

  def self.down
    drop_table :spots
  end
end
