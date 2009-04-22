class Organization < ActiveRecord::Base
  has_many :projects
  has_many :organization_memberships
  has_many :members, :through => :organization_memberships
end
