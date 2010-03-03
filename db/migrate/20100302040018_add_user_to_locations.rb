class AddUserToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :user_id, :integer
    add_column :locations, :status, :integer
  end

  def self.down
    remove_column :locations, :status
    remove_column :locations, :user_id
  end
end
