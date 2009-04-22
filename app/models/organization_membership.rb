class OrganizationMembership < ActiveRecord::Base
  belongs_to :organization
  belongs_to :member
  #validates_uniqueness_of :member, :organization
end
