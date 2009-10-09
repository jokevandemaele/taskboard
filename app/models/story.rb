class Story < ActiveRecord::Base
  belongs_to :project
  has_many :tasks, :dependent => :destroy

  validates_presence_of :realid, :project_id

  after_create :add_template_task
  before_save :default_priority
  
  
  def self.find_by_team(team)
    stories = []
    team.projects.each do |project|
      project.stories.each { |story| stories << story }
    end
    stories = stories.sort_by {|story| [story.priority, story.updated_at] }
    stories.reverse
    # stories = stories.sort_by {|story|  }
    # stories.reverse
  end
  def after_initialize
    self.realid = Story.next_realid(self.project) if !self.realid && self.project
    self.priority = self.project.next_priority if !self.priority && self.project
  end
  
  def add_template_task
    self.tasks << Task.new(:name => "Add tasks")
  end

  def default_priority
    return self.priority = -1 if self.finished?
    return self.priority if self.priority && self.priority >= 0
    return self.priority = 0 if self.priority && self.priority < 0
    return project.next_priority
  end

  # def next_priority(project_id)
  #   story = Story.first(:conditions => [ "project_id = ? AND priority != -1 ", project_id ], :order => "priority ASC")
  #   last_priority = (!story.nil?) ? story.priority : nil
  #   return self.priority = (last_priority > 10) ? last_priority - 10 : 0 if last_priority
  #   return self.priority = 2000 if !last_priority
  # end
  
  def self.next_realid(project_id)
  	story = Story.first(:conditions => ["project_id = ? AND realid != ''", project_id], :order => "realid DESC")

  	if story
  	  lastid = story.realid
  		number = lastid.gsub(/\D/, '').to_i
  		text = lastid.gsub(/\d/, '')
  		number += 1
  		id = (number < 10) ? "#{text}00#{number}" : "#{text}#{number}"
  		id = "#{text}0#{number}" if (number >= 10 && number < 100)
  		return id
  	else 
    	project = Project.find(project_id)
    	return Story.get_initials_of(project.name,2) + '001'
  	end
  end

  def self.get_initials_of(string,limit = 0)
	if string.empty?
		return ""
	end
	initials = String.new
	words = string.split

	if words.size == 1
		if words[0].length > 2
			initials << words[0][0] << words[0][1]
		else
			initials << words[0][0]
		end	
	else
		words.each do |word|		
			initials << word[0]
		end
	end
	if limit > 0
		return initials.upcase[0..limit-1]
	else
		return initials.upcase
	end
  end
  
  def stopped?
    self.status == 'not_started'
  end

  def started?
    self.status == 'in_progress'
  end

  def finished?
    self.status == 'finished'
  end

  def start
    self.status = 'in_progress'
    return self.save
  end

  def stop
    self.status = 'not_started'
    return self.save
  end

  def finish
    self.status = 'finished'
    self.priority = -1
    return self.save
  end

end
