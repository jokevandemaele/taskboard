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
  validates_presence_of :realid, :project

  ################################################################################################################
  #
  # Attributes Accessible
  #
  ################################################################################################################
  attr_accessible :name, :priority, :size, :description, :realid

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
  before_save :default_priority
  after_create :add_template_task  


  ################################################################################################################
  #
  # Instance Methods
  #
  ################################################################################################################
  def after_initialize
    self.realid = project.next_realid if !realid && project
    self.priority = self.project.next_priority if !self.priority && self.project
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

private  
  def add_template_task
    self.tasks << Task.new(:name => "Add tasks")
  end

  def default_priority
    return self.priority = -1 if self.finished?
    return self.priority if self.priority && self.priority >= 0
    return self.priority = 0 if self.priority && self.priority < 0
    return project.next_priority
  end
end
