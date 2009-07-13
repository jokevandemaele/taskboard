class OrganizationMembership < ActiveRecord::Base
  belongs_to :organization
  belongs_to :member

  # IMPORTANT: This named scope references _ONLY_ the Organization Memberships, it doesn't takes in account if the user is a system admin.
  # If you want to get the organizations a user can administer use member.organizations_administered 
  named_scope :administered, :conditions => { :admin => true }
end
