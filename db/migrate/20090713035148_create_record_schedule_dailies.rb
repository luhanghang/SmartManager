class CreateRecordScheduleDailies < ActiveRecord::Migration
  def self.up
    create_table :record_schedule_dailies do |t|
      t.references :spot
      t.integer :start_hour
      t.integer :start_min
      t.integer :end_hour
      t.integer :end_min
      t.integer :last_time
      t.date :schedule_date
      t.integer :enabled
      t.integer :color, :default => -1
      t.timestamps
    end
  end

  def self.down
    drop_table :record_schedule_dailies
  end
end
