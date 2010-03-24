class CreateLocationsCriterias < ActiveRecord::Migration
  def self.up
    create_table :locations_criterias do |t|
      t.references :criteria
      t.references :location
      t.integer :rating

      t.timestamps
    end
  end

  def self.down
    drop_table :locations_criterias
  end
end
