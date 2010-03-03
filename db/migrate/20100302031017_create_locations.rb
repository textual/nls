class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :name
      t.text :full_address
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zip
      t.string :country_code
      t.string :province
      t.string :lat
      t.string :lng
      t.string :phone
      t.string :website
      t.integer :rating
      
      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
