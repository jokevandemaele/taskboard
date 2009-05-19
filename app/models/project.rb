class Project < ActiveRecord::Base
  # Associations
  belongs_to :organization
  has_many :stories
  has_and_belongs_to_many :teams
  
  # Named Scopes
  # Free projects are projects that don't have an organization assigned
  named_scope :free, :conditions => { :organization_id => 0 }
  
  # stories_by_priority: return all project's stories ordered by priority (highest on top)
  def stories_by_priority
    return stories.all(:order => "priority DESC, updated_at DESC")
  end

  # stories_in_progress: return all project's stories that are in progress ordered by priority (highest on top)
  def stories_in_progress
    return stories.all(:conditions => "status = 'in_progress'", :order => "priority DESC")
  end
 
  # members: returns an array with all the members of the project
  def members
    members = Array.new
    teams.each do |team| 
      team.members.each { |member| members << member if !members.include?(member)}
    end
    return members
  end
end
