class CreateEventsTypesAgain < ActiveRecord::Migration
  def self.up
    create_table :events_types do |t|
      t.references :event
      t.references :event_type
    end
  end

  def self.down
    drop_table :events_types
  end
end
