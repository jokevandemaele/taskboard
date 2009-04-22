class CreateOrganizationMemberships < ActiveRecord::Migration
  def self.up
    create_table :organization_memberships do |t|
      t.integer :organization_id
      t.integer :member_id
      t.boolean :admin
      t.timestamps
    end
  end

  def self.down
    drop_table :organization_memberships
  end
end
