class Organization < ActiveRecord::Base
  has_many :projects
  has_many :teams
  has_many :organization_memberships
  has_many :members, :through => :organization_memberships
  validates_uniqueness_of :name

  def members_ordered_by_role
    admins = []
    org_admins = []
    normal = []
    self.members.each do |member|
      normal << member if !member.admin? && !member.admins?(self)
      org_admins << member if !member.admin? && member.admins?(self)
      admins << member if member.admin?
    end
    
    return admins + org_admins + normal
  end

end
