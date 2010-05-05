class ChangeUsersFbType < ActiveRecord::Migration
  def self.up
    execute("ALTER TABLE users CHANGE fb_user_id BIGINT")
  end

  def self.down
  end
end
