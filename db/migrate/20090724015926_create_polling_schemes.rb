class CreatePollingSchemes < ActiveRecord::Migration
  def self.up
    create_table :polling_schemes do |t|
      t.references :user
      t.string :name
      t.integer :interval
      t.timestamps
    end
  end

  def self.down
    drop_table :polling_schemes
  end
end
