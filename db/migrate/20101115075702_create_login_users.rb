class CreateLoginUsers < ActiveRecord::Migration
  def self.up
    create_table :login_users do |t|
	  t.references :user
	  t.string :session_id
      t.datetime :logintime
	  t.datetime :lasttime
      t.timestamps
    end
  end

  def self.down
    drop_table :login_users
  end
end
