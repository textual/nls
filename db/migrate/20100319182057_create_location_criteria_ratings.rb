class CreateLocationCriteriaRatings < ActiveRecord::Migration
  def self.up
    create_table :location_criteria_ratings do |t|
      t.references :user
      t.references :locations_criteria
      t.integer :rating
      t.text :comment
    
      t.timestamps
    end
  end

  def self.down
    drop_table :location_criteria_ratings
  end
end
