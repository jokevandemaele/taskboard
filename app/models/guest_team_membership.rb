class GuestTeamMembership < ActiveRecord::Base
  # Associations
  belongs_to :member
  belongs_to :project
  belongs_to :team
  
  # Validations
  validates_presence_of :member, :message => ": There is no Member with that E-mail."
  validates_presence_of :project, :message => ": You must select a project"
  
  def validate
    errors.add_to_base("That member belongs to the organization you're administering, there is no need to add it as a guest") if !project.nil? && project.organization.members.include?(member)
    errors.add_to_base "That member is already a guest member on #{Project.find(project).name}" if GuestTeamMembership.first(:conditions => ["member_id = ? AND project_id = ?", member, project])
  end
  
  def self.remove_from_organization(member,organization)
    organization.projects.each do |project|
      remove_from_project(member,project)
    end
  end

  def self.remove_from_project(member,project)
    if project.guest_members.include?(member)
      project.stories.each { |story| story.tasks.each { |task| task.nametags.each { |nametag| nametag.destroy if nametag.member == member } }}
      project.guest_members.delete(member)
    end
  end
  
  def self.add_to_project(member,project)
    @guest_team_member = GuestTeamMembership.new(:project => project, :member => member)
    return @guest_team_member.save
  end
  
end
