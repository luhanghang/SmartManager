class CreateMaps < ActiveRecord::Migration
  def self.up
    create_table :maps do |t|
      t.string :name
      t.integer :parent_id, :default => 0
      t.integer :web, :default => 0
      t.string :city
      t.references :company
      t.timestamps
    end

    create_table :map_spots, :id => false do |t|
      t.references :spot
      t.references :map
      t.integer :x
      t.integer :y
    end

    create_table :spot_gps_records, :id => false do |t|
      t.references :spot
      t.references :map
      t.integer :x
      t.integer :y
      t.timestamps
    end
    
    execute("ALTER TABLE map_spots MODIFY x numeric(11,5);")
    execute("ALTER TABLE map_spots MODIFY y numeric(11,5);")
  end

  def self.down
    drop_table :maps
  end
end
