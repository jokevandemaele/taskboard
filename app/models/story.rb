class Story < ActiveRecord::Base
  belongs_to :project
  has_many :tasks, :dependent => :destroy

  validates_presence_of :realid
  validates_uniqueness_of :realid
  
  after_create :add_template_task
  after_save :default_priority
  
  def add_template_task
    self.tasks << Task.new(:name => "This is a sample task")
  end

  def default_priority
    self.priority = 0 if !self.priority
  end

  def self.last_realid(project_id)
  	story = Story.first(:conditions => ["project_id = ? AND realid != ''", project_id], :order => "realid DESC")
  	if story
  		return story.realid
  	else 
  	project = Project.find(project_id)
  	number = '001'
  	text = Story.get_initials_of(project.name,2)
  	return text + number
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
