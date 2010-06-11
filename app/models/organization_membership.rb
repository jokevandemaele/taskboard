class OrganizationMembership < ActiveRecord::Base
  ################################################################################################################
  #
  # Validations
  #
  ################################################################################################################
  validates_presence_of :organization, :user
  attr_accessible :organization, :user
  
  ################################################################################################################
  #
  # Associations
  #
  ################################################################################################################
  belongs_to :organization
  # belongs_to :member
  belongs_to :user

  before_create :make_first_user_admin
  after_create :add_user_to_default_team

  # IMPORTANT: This named scope references _ONLY_ the Organization Memberships, it doesn't takes in account if the user is a system admin.
  # If you want to get the organizations a user can administer use member.organizations_administered 
  named_scope :administered, :conditions => { :admin => true }

  def make_first_user_admin
    self.admin = organization.organization_memberships.empty?
    return true
  end

  def add_user_to_default_team
    organization.teams.first.users << user if organization.teams.size == 1
  end
end
