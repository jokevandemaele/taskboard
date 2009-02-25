class CreateProjectTeamJoinTable < ActiveRecord::Migration
  def self.up
    create_table :projects_teams, :id => false do |t| 
      t.integer :project_id  
      t.integer :team_id 
    end
  end

  def self.down
    drop_table :projects_teams  
  end
end
