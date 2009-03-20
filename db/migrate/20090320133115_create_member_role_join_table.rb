class CreateMemberRoleJoinTable < ActiveRecord::Migration
  def self.up
    create_table :members_roles, :id => false do |t| 
      t.integer :member_id  
      t.integer :role_id 
    end
  end

  def self.down
    drop_table :members_roles  
  end
end
