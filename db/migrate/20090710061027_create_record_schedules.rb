class CreateRecordSchedules < ActiveRecord::Migration
  def self.up
    create_table :record_schedules do |t|
      t.references :spot
      t.integer :start_hour
      t.integer :start_min
      t.integer :end_hour
      t.integer :end_min
      t.integer :last_time
      t.integer :week_day
      t.integer :enabled
      t.integer :color, :default => -1
      t.timestamps
    end
  end

  def self.down
    drop_table :record_schedules
  end
end
