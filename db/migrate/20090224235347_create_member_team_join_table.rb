class CreateMemberTeamJoinTable < ActiveRecord::Migration
  def self.up
    create_table :members_teams, :id => false do |t| 
      t.integer :member_id  
      t.integer :team_id
    end
  end

  def self.down
    drop_table :members_teams
  end
end
