class ChangeUsersFbType < ActiveRecord::Migration
  def self.up
    execute("ALTER TABLE users ALTER COLUMN fb_user_id TYPE BIGINT")
  end

  def self.down
  end
end
