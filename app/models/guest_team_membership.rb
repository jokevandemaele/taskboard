class GuestTeamMembership < ActiveRecord::Base
  # Associations
  belongs_to :member
  belongs_to :project
  belongs_to :team
  
  # Validations
  validates_presence_of :member, :message => ": There is no Member with that E-mail."
  validates_presence_of :project, :message => ": You must select a project"
  
  def validate
     errors.add_to_base "That member is already a guest member on #{Project.find(project).name}" if GuestTeamMembership.first(:conditions => ["member_id = ? AND project_id = ?", member, project])
  end
end
