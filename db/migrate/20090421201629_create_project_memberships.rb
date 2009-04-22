class CreateProjectMemberships < ActiveRecord::Migration
  def self.up
    create_table :project_memberships do |t|
      t.integer :project_id
      t.integer :member_id
      t.boolean :product_owner

      t.timestamps
    end
  end

  def self.down
    drop_table :project_memberships
  end
end
