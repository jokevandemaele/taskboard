class OrganizationMembership < ActiveRecord::Base
  belongs_to :organization
  belongs_to :member

  before_create :make_first_member_admin
  after_create :add_member_to_default_team

  # IMPORTANT: This named scope references _ONLY_ the Organization Memberships, it doesn't takes in account if the user is a system admin.
  # If you want to get the organizations a user can administer use member.organizations_administered 
  named_scope :administered, :conditions => { :admin => true }

  def make_first_member_admin
    self.admin = (organization.members.empty?) ? true : nil unless self.admin
  end

  def add_member_to_default_team
    organization.teams.first.members << member if organization.teams.size == 1
  end
end
