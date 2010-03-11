class Task < ActiveRecord::Base
  ################################################################################################################
  #
  # Validations
  #
  ################################################################################################################
  validates_presence_of :story

  ################################################################################################################
  #
  # Associations
  #
  ################################################################################################################
  belongs_to :story
  has_many :nametags, :dependent => :delete_all
  has_many :statustags, :dependent => :delete_all

  ################################################################################################################
  #
  # Attributes accessible
  #
  ################################################################################################################
  attr_accessible :story, :name, :description
  

  ################################################################################################################
  #
  # Attributes accessible
  #
  ################################################################################################################
  named_scope :not_started, :conditions => { :status => "not_started" }
  named_scope :in_progress, :conditions => { :status => "in_progress" }
  named_scope :finished, :conditions => { :status => "finished" }
  
  ################################################################################################################
  #
  # Instance Methods
  #
  ################################################################################################################
  def remove_tags
    self.statustags.clear
    self.nametags.clear
  end

  def start
    self.status = 'in_progress'
    save
  end

  def stop
    self.status = 'not_started'
    save
  end

  def finish
    self.status = 'finished'
    remove_tags
    save
  end

end
