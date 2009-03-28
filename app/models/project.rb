class Project < ActiveRecord::Base
  has_many :stories
  has_and_belongs_to_many :teams
  
	
  # stories_by_priority: return all project's stories order by priority (highest on top)
  def stories_by_priority
    return Story.all(:all, :conditions => "project_id = #{self.id}", :order => "priority DESC, updated_at DESC")
  end

  def stories_in_progress
    return Story.all(:all, :conditions => "project_id = #{self.id} AND status = 'in_progress'", :order => "priority DESC")
  end
 
  # members: returns an array with all the members of the project
  def members
    members = Array.new
    self.teams.each do |team| 
      team.members.each { |member| members << member if !members.include?(member)}
    end
    return members
  end
end
