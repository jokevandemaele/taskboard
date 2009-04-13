class Task < ActiveRecord::Base
  belongs_to :story
  has_many :nametags, :dependent => :delete_all
  has_many :statustags, :dependent => :delete_all

  # Named Scopes
  # Task tatus named scopes
  named_scope :not_started, :conditions => { :status => "not_started" }
  named_scope :in_progress, :conditions => { :status => "in_progress" }
  named_scope :finished, :conditions => { :status => "finished" }
  def remove_tags
    self.statustags.clear
    self.nametags.clear
  end
  
  def self.tasks_by_status(story,status)
    @tasks = []
    if(status == "in_progress")
      @tasks = story.tasks.in_progress
    end
    if(status == "not_started")
      @tasks = story.tasks.not_started
    end
    if(status == "finished")
      @tasks = story.tasks.finished
    end
    return @tasks
  end
end
