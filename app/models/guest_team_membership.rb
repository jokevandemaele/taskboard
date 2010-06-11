class GuestTeamMembership < ActiveRecord::Base
  ################################################################################################################
  #
  # Validations
  #
  ################################################################################################################
  validates_presence_of :user, :message => ": There is no user with that E-mail."
  validates_presence_of :project, :message => ": You must select a project"

  ################################################################################################################
  #
  # Associations
  #
  ################################################################################################################
  belongs_to :user
  belongs_to :member
  belongs_to :project
  belongs_to :team
  
  ################################################################################################################
  #
  # Attributes Accessible
  #
  ################################################################################################################
  attr_accessible :team, :project, :user
  
  def validate
    errors.add_to_base("That user belongs to the organization you're administering, there is no need to add it as a guest") if !project.nil? && project.organization.users.include?(user)
    errors.add_to_base "That user is already a guest member on #{Project.find(project).name}" if GuestTeamMembership.first(:conditions => ["user_id = ? AND project_id = ?", user, project])
  end
  
  ################################################################################################################
  #
  # Class Methods
  #
  ################################################################################################################
  
  def self.remove_from_organization(user,organization)
    organization.projects.each { |project| remove_from_project(user,project) }
  end

  def self.remove_from_project(user,project)
    if project.guest_members.include?(user)
      project.stories.each { |story| story.tasks.each { |task| task.nametags.each { |nametag| nametag.destroy if nametag.user == user } }}
      project.guest_members.delete(user)
    end
  end
end
