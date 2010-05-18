class ChangeLatLngDataType < ActiveRecord::Migration
  def self.up
    remove_column :locations, :lat
    remove_column :locations, :lng
    
    add_column :locations, :lat, :decimal
    add_column :locations, :lng, :decimal
    
  end

  def self.down
  end
end
