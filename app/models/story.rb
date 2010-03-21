class Story < ActiveRecord::Base
  ################################################################################################################
  #
  # Associations
  #
  ################################################################################################################
  belongs_to :project
  has_many :tasks, :dependent => :destroy

  ################################################################################################################
  #
  # Validations
  #
  ################################################################################################################
  validates_presence_of :realid, :project, :name, :priority

  ################################################################################################################
  #
  # Attributes Accessible
  #
  ################################################################################################################
  attr_accessible :name, :priority, :size, :description, :realid, :project

  ################################################################################################################
  #
  # Named Scopes
  #
  ################################################################################################################
  default_scope :order => "priority DESC, updated_at DESC"
  named_scope :in_progress, :conditions => {:status => 'in_progress'}
  named_scope :not_started, :conditions => {:status => 'not_started'}
  named_scope :finished, :conditions => {:status => 'finished', :priority => -1}

  ################################################################################################################
  #
  # CALLBACKS
  #
  ################################################################################################################
  before_save :set_default_priority, :set_default_realid
  before_create :set_default_priority, :set_default_realid
  after_create :add_template_task

  def after_initialize
    set_default_priority if project
    set_default_realid if project
  end
  
  ################################################################################################################
  #
  # Instance Methods
  #
  ################################################################################################################
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

  def default_priority
    return self.priority = -1 if self.finished?
    return self.priority if self.priority && self.priority >= 0
    return self.priority = 0 if self.priority && self.priority < 0
    return project.next_priority
  end

private  
  def add_template_task
    self.tasks << Task.new(:name => "Add tasks")
  end

  def set_default_priority
    self.priority = default_priority if !priority
  end
  
  def set_default_realid
    self.realid = project.next_realid if !realid
  end
end
