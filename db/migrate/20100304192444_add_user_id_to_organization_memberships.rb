class AddUserIdToOrganizationMemberships < ActiveRecord::Migration
  def self.up
    add_column :organization_memberships, :user_id, :integer
    add_index :organization_memberships, :user_id
  end

  def self.down
    remove_index :organization_memberships, :user_id
    remove_column :organization_memberships, :user_id
  end
end
