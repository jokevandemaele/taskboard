class Team < ActiveRecord::Base
  # Associations
  belongs_to :organization
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :members
  #has_many :guest_team_memberships
  
  # Validations
  validates_uniqueness_of :name
end
