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
  belongs_to :last_project, :class_name => "Project"
  has_many :nametags, :dependent => :destroy
  
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
  attr_accessible :name, :color, :login, :email, :password, :password_confirmation, :new_organization, :avatar
  attr_accessor :added_by, :new_organization

  ################################################################################################################
  #
  # Callbacks
  #
  ################################################################################################################
  after_create :add_to_organization_if_new_organization_present
  
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

  # add user to organization
  def add_to_organization(organization)
    if organization
      self.organization_memberships.build(:organization => organization) 
      self.save
    end
  end

  # remove the user from organization
  def remove_from_organization(organization)
    if organization
      
      organization_membership = organization_memberships.first(:conditions => ["organization_id = ?", organization.id])
      organization_membership.destroy
      
      organization.teams.each { |team| team.users.delete(self) }
    end
  end

  # returns the correct name of a member to display in it's nametag
  def formatted_nametag(team = nil)
    if(team)
      @team = Team.find(team)
      users = @team.users
    else
      users = User.all()
    end
    
    names = name.split()
    name = names[0]
    users = users - [self]
    users.each do |user|
    user_nametag = user.name.split()
      name = "#{names[0]} #{names[1][0,1]}" if user_nametag[0] == names[0] && names.length > 1
    end
    return name.upcase()[0..8]
  end

  # returns the administrators for the organization the user is in
  def administrators
    organizations.collect { |organization| organization.admins }.flatten
  end

private
  # This function is called when a user is created to add to the organization passed
  def add_to_organization_if_new_organization_present
    add_to_organization(new_organization) if(new_organization)
  end  
end
