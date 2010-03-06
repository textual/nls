class CreateReviews < ActiveRecord::Migration
  def self.up
    create_table :reviews do |t|
      t.integer :rating
      t.text :comment
      t.references :location
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :reviews
  end
end
