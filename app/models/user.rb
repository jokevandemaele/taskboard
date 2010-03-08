class User < ActiveRecord::Base
  ################################################################################################################
  #
  # Validations
  #
  ################################################################################################################
  validates_presence_of :login, :email

  ################################################################################################################
  #
  # Associations
  #
  ################################################################################################################
  has_and_belongs_to_many :teams
  has_many :organization_memberships, :dependent => :destroy 
  has_many :organizations, :through => :organization_memberships
  has_many :guest_team_memberships
  has_many :guest_projects, :through => :guest_team_memberships, :source => :project
  
  ################################################################################################################
  #
  # Mixins
  #
  ################################################################################################################
  acts_as_authentic
  has_attached_file :avatar, :styles => { :medium => "200x200#", :thumb => "88x88#" }
  
  ################################################################################################################
  #
  # Attributes Accessible
  #
  ################################################################################################################
  attr_accessible :name, :color, :login, :email, :password, :password_confirmation

  ################################################################################################################
  #
  # Constants
  #
  ################################################################################################################

  ################################################################################################################
  #
  # Instance Methods
  #
  ################################################################################################################
  
  # toggle the user system administration privileges
  def toggle_admin!
    self.admin = !admin?
    self.save
  end
  # returns all the organizations that the user admins
  # if the user is a system administrator it returns all the organizations available
  def organizations_administered
    self.admin? ? Organization.all : organization_memberships.administered.collect {|membership| membership.organization }
  end
  
  # returns true if the user admins at least one organization
  def admins_any_organization?
    !organizations_administered.empty?
  end
  
  # returns true if the user admins the given organization
  def admins?(organization)
    self.organizations_administered.include?(organization)
  end
  
  # returns the projects the user belongs to
  def projects
    projects = []
    self.teams.each do |team| 
      team.projects.each {|project| projects << project if !projects.include?(project) }
    end
    projects += self.guest_projects
    return projects
  end
  
end
