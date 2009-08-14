class MigrateTeamsData < ActiveRecord::Migration
  def self.up
    teams = Team.all
    teams.each do
      |team| team.organization_id = team.projects.first.organization_id if !team.projects.empty? 
      team.save
    end
  end

  def self.down
    teams = Team.all
    teams.each { |team| team.organization_id = nil }
  end
end
