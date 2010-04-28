class CreateEventDatesAgain < ActiveRecord::Migration
  def self.up
    create_table :event_dates do |t|
      t.references :event
      t.integer :day
      t.date :date
      
      t.boolean :use_event_desc, :default => true
      t.boolean :use_event_time, :default => true
      t.boolean :use_event_price, :default => true
      
      t.integer :rating
      
    end
  end

  def self.down
    drop_table :event_dates
  end
end
