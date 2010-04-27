class CreateEventInfo < ActiveRecord::Migration
  def self.up
    create_table :event_info do |t|
      t.integer :info_id
      t.string :info_type
      
      t.text :desc
      
      t.time :time_from
      t.time :time_to
      t.boolean :time_all_day
      
      t.decimal :price_at_door
      t.decimal :price_advance
      t.date :price_advance_expires
      t.string :purchase_url      
    end
  end

  def self.down
    drop_table :event_info
  end
end
