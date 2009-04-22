class AddAdminColumnToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :admin, :bool, :default => nil
  end

  def self.down
    remove_column :members, :admin
  end
end
