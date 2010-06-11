class AddUserId < ActiveRecord::Migration
  def self.up
    add_column :organization_memberships, :user_id, :integer
    add_index :organization_memberships, :user_id

    add_column :guest_team_memberships, :user_id, :integer
    add_index :guest_team_memberships, :user_id

    add_column :nametags, :user_id, :integer
    add_index :nametags, :user_id
  end

  def self.down
    remove_index :organization_memberships, :user_id
    remove_column :organization_memberships, :user_id

    remove_index :guest_team_memberships, :user_id
    remove_column :guest_team_memberships, :user_id

    remove_index :nametags, :user_id
    remove_column :nametags, :user_id
  end
end
