class AddGeometryColumnsTable < ActiveRecord::Migration
  def self.up
    create_table :geometry_columns do |t|
      t.string :f_table_catalog
      t.string :f_table_schema
      t.string :f_table_name
      t.string :f_geometry_column
      t.integer :coord_dimension
      t.integer :srid
      t.string :type
    end
  end

  def self.down
    drop_table :geometry_columns
  end
end
