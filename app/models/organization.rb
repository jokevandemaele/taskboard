class Organization < ActiveRecord::Base
  ################################################################################################################
  #
  # Validations
  #
  ################################################################################################################
  validates_presence_of :name
  validates_uniqueness_of :name
  
  ################################################################################################################
  #
  # Associations
  #
  ################################################################################################################
  has_many :projects, :dependent => :destroy
  has_many :teams, :dependent => :destroy
  has_many :organization_memberships, :dependent => :destroy
  has_many :users, :through => :organization_memberships
  has_many :members, :through => :organization_memberships  # Remove after migration

  ################################################################################################################
  #
  # Attributes Accessible
  #
  ################################################################################################################
  attr_accessible :name
  
  ################################################################################################################
  #
  # Callbacks
  #
  ################################################################################################################
  after_create :add_default_team_and_project

  ################################################################################################################
  #
  # Instance Methods
  #
  ################################################################################################################

  def users_ordered_by_role
    admins = []
    org_admins = []
    normal = []
    users.each do |user|
      normal << user if !user.admin? && !user.admins?(self)
      org_admins << user if !user.admin? && user.admins?(self)
      admins << user if user.admin?
    end
    return admins + org_admins + normal
  end
  
  def teams_ordered_for_user(user)
    teams = self.teams
    teams_ordered_for_user = []
    teams.each { |team| teams_ordered_for_user << team if team.users.include?(user) }
    teams.each { |team| teams_ordered_for_user << team if !team.users.include?(user) }
    return teams_ordered_for_user
  end

  def projects_ordered_for_user(user)
    projects = self.projects
    projects_ordered_for_user = []
    projects.each { |project| projects_ordered_for_user << project if project.users.include?(user) }
    projects.each { |project| projects_ordered_for_user << project if !project.users.include?(user) }
    return projects_ordered_for_user
  end

  def guest_members
    guests = []
    self.projects.each do |project|
      project.guest_members.each { |member| guests << member if !(guests.include?(member))}
    end
    return guests
  end
  
  # returns the administrators for the organization
  def admins
    organization_memberships.administered.collect {|membership| membership.user }
  end
private
  # adds the default project and team needed when creating an organization
  def add_default_team_and_project
    # Add default team
    teams.create(:name => "#{self.name} Team")
    # Add default project
    project = projects.create(:name => "#{name} Project")
    # Add default team to default project
    projects.first.teams << teams.first
    project.save
  end
  

end
