class Organization < ActiveRecord::Base
  # Associations
  has_many :projects
  has_many :teams
  has_many :organization_memberships
  has_many :members, :through => :organization_memberships
  validates_uniqueness_of :name

  # Callbacks
  after_create :add_default_team_and_project

  def add_default_team_and_project
    team = Team.create(:name => "#{self.name} Team", :organization => self, :color => "3771c8")
    project = Project.create(:name => "#{self.name} Project", :organization => self, :teams => [team])
  end

  def members_ordered_by_role
    admins = []
    org_admins = []
    normal = []
    self.members.each do |member|
      normal << member if !member.admin? && !member.admins?(self)
      org_admins << member if !member.admin? && member.admins?(self)
      admins << member if member.admin?
    end
    logger.error(" ----------------------------------------- "+ (admins + org_admins + normal).inspect)
    return admins + org_admins + normal
  end
  
  def teams_ordered_for_member(member)
    teams = self.teams
    teams_ordered_for_member = []
    teams.each { |team| teams_ordered_for_member << team if team.members.include?(member) }
    teams.each { |team| teams_ordered_for_member << team if !team.members.include?(member) }
    return teams_ordered_for_member
  end

  def projects_ordered_for_member(member)
    projects = self.projects
    projects_ordered_for_member = []
    projects.each { |project| projects_ordered_for_member << project if project.members.include?(member) }
    projects.each { |project| projects_ordered_for_member << project if !project.members.include?(member) }
    return projects_ordered_for_member
  end

  def guest_members
    guests = []
    self.projects.each do |project|
      project.guest_members.each { |member| guests << member if !(guests.include?(member))}
    end
    return guests
  end
end
