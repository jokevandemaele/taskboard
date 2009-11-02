class AddPublicFieldToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :public, :boolean, :default => false
    add_column :projects, :public_hash, :string
  end

  def self.down
    remove_column :projects, :public_hash
    remove_column :projects, :public
  end
end
