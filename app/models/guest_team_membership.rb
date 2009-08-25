class GuestTeamMembership < ActiveRecord::Base
  # Associations
  belongs_to :member
  belongs_to :project
  belongs_to :team
  
  # Validations
  validates_presence_of :member
  validates_presence_of :project
  validates_presence_of :team
end
