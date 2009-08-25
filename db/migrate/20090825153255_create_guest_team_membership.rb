class CreateGuestTeamMembership < ActiveRecord::Migration
  def self.up
    create_table :guest_team_memberships do |t|
      t.integer :member_id
      t.integer :project_id
      t.integer :team_id
      t.timestamps
    end
  end

  def self.down
    drop_table :guest_team_memberships
  end
end