class CreatePollingSchemeItems < ActiveRecord::Migration
  def self.up
    create_table :polling_scheme_items do |t|
      t.references :polling_scheme
      t.integer :item_type
      t.references :spot
      t.references :spot_presetting
      t.timestamps
    end
  end

  def self.down
    drop_table :polling_scheme_items
  end
end
