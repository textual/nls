class AddAddress2ToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :address_2, :string
  end

  def self.down
    remove_column :locations, :address_2
  end
end
