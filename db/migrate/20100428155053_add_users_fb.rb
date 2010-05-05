class AddUsersFb < ActiveRecord::Migration
  def self.up
    add_column :users, :fb_user_id, :integer
    add_column :users, :email_hash, :string
    #if mysql
    #execute("ALTER TABLE users ALTER COLUMN fb_user_id BIGINT()")
  end

  def self.down
    remove_column :users, :fb_user_id
    remove_column :users, :email_hash
  end
end
