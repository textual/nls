class ChangeUsersFbType < ActiveRecord::Migration
  def self.up
    execute("ALTER TABLE users MODIFY COLUMN fb_user_id BIGINT")
  end

  def self.down
  end
end
