class CreateSpotPresettings < ActiveRecord::Migration
  def self.up
    create_table :spot_presettings do |t|
      t.references :spot
      t.integer :position
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :spot_presettings
  end
end
