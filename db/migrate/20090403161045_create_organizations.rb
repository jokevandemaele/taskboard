class CreateOrganizations < ActiveRecord::Migration
  def self.up
    create_table :organizations do |t|
      t.string :name

      t.timestamps
    end

    # Add project -> organization relation
    add_column :projects, :organization_id, :integer, :default => 0
    
    # Add member -> organization relation
    create_table :members_organizations, :id => false do |t| 
      t.integer :member_id  
      t.integer :organization_id 
    end
  end

  def self.down
    drop_table :organizations
    remove_column :projects, :organization_id
    drop_table :members_organizations
  end
end
