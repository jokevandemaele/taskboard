class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :guest_team_memberships, :member_id
    add_index :guest_team_memberships, :project_id
    add_index :guest_team_memberships, :team_id
    add_index :members, [:username, :hashed_password]
    add_index :members_organizations, :member_id
    add_index :members_organizations, :organization_id
    add_index :members_teams, :member_id
    add_index :members_teams, :team_id
    add_index :organization_memberships, :organization_id
    add_index :organization_memberships, :member_id
    add_index :organization_memberships, :admin
    add_index :project_memberships, :project_id
    add_index :project_memberships, :member_id
    add_index :projects, :organization_id
    add_index :projects_teams, :project_id
    add_index :projects_teams, :team_id
    add_index :nametags, :task_id
    add_index :statustags, :task_id
    add_index :stories, :project_id
    add_index :stories, :realid
    add_index :tasks, :story_id
    add_index :tasks, :status
    add_index :teams, :organization_id
  end

  def self.down
    remove_index :teams, :organization_id
    remove_index :tasks, :status
    remove_index :tasks, :story_id
    remove_index :stories, :realid
    remove_index :stories, :project_id
    remove_index :statustags, :task_id
    remove_index :nametags, :task_id
    remove_index :projects_teams, :team_id
    remove_index :projects_teams, :project_id
    remove_index :projects, :organization_id
    remove_index :project_memberships, :mem
    remove_index :project_memberships, :project_id
    remove_index :organization_memberships, :admin
    remove_index :organization_memberships, :member_id
    remove_index :organization_memberships, :organization_id
    remove_index :members_teams, :team_id
    remove_index :members_teams, :member_id
    remove_index :members_organizations, :organization_id
    remove_index :members_organizations, :member_id
    remove_index :members, :username
    remove_index :guest_team_memberships, :team_id
    remove_index :guest_team_memberships, :project_id
    remove_index :guest_team_memberships, :member_id
  end
end
