class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.references :user
      t.string :account
      t.references :company
      t.string :user_name
	  t.string :operation
      t.timestamps
    end
  end

  def self.down
    drop_table :logs
  end
end
