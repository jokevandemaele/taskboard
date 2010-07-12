class Team < ActiveRecord::Base
  ################################################################################################################
  #
  # Associations
  #
  ################################################################################################################
  belongs_to :organization
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :members
  has_and_belongs_to_many :users

  ################################################################################################################
  #
  # Validations
  #
  ################################################################################################################
  validates_uniqueness_of :name
  validates_presence_of :name, :organization

  ################################################################################################################
  #
  # Attributes Accessible
  #
  ################################################################################################################
  attr_accessible :name, :color

  ################################################################################################################
  #
  # Instance methods
  #
  ################################################################################################################
  def stories
    project_ids = projects.collect { |project| project.id }
    Story.all(:conditions => {:project_id => project_ids}, :order => "priority DESC, updated_at DESC")
  end
  
  def next_priority
    priorities = projects.collect {|p| p.next_priority}
    priorities.sort!
    priorities.first
  end
end
