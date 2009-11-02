require 'digest/sha1'

class Project < ActiveRecord::Base
  # Associations
  belongs_to :organization
  has_many :stories, :dependent => :delete_all
  has_and_belongs_to_many :teams
  has_many :guest_team_memberships
  has_many :guest_members, :through => :guest_team_memberships, :source => :member
  
  # Validations
  validates_uniqueness_of :name
  
  #Callbacks
  after_create :add_default_stories
  before_save :add_hash_if_public
  
  # Named Scopes
  # Free projects are projects that don't have an organization assigned
  named_scope :free, :conditions => { :organization_id => 0 }
  
  def add_hash_if_public
    self.public_hash = self.public? ? Digest::SHA1.hexdigest(self.name + Time.now.to_s) : nil
  end
  
  # add_default_stories: this function is called when a new project is created, it adds the sample stories to it
  def add_default_stories
    story = Story.create(:project => self, :name => "Sample Started Story", :priority => 2000, :size => 10, :status => "in_progress", :description => "This is a sample story that is started, edit it to begin using this project")
    story2 = Story.create(:project => self, :name => "Sample Not Started Story", :priority => 1990, :size => 10, :status => "not_started", :description => "This is a sample story that is not started, edit it to begin using this project")
  end
  
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
    members += guest_members
    return members
  end

  def team_including(member)
    result = self.teams.first
    self.teams.each { |team| result = team if(team.members.include?(member)) }
    return result
  end
  
  def next_priority
    story = self.stories.first(:conditions => "priority != -1 ", :order => "priority ASC")
    last_priority = (!story.nil?) ? story.priority : nil
    return (last_priority > 10) ? last_priority - 10 : 0 if last_priority
    return 2000 if !last_priority
  end
end
