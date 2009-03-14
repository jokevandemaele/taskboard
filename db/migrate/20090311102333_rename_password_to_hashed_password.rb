class RenamePasswordToHashedPassword < ActiveRecord::Migration
  def self.up
    rename_column :members, :password, :hashed_password
  end

  def self.down
    rename_column :members, :hashed_password, :password
  end
end
