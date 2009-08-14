class AddOrganizationIdToTeams < ActiveRecord::Migration
  def self.up
    add_column :teams, :organization_id, :integer
  end

  def self.down
    remove_column :teams, :organization_id
  end
end
