require 'digest/sha1'

class Project < ActiveRecord::Base
  ################################################################################################################
  #
  # Validations
  #
  ################################################################################################################
  validates_presence_of :organization, :name
  validates_uniqueness_of :name

  ################################################################################################################
  #
  # Associations
  #
  ################################################################################################################
  belongs_to :organization
  has_many :stories, :dependent => :delete_all
  has_and_belongs_to_many :teams
  has_many :guest_team_memberships
  has_many :guest_members, :through => :guest_team_memberships, :source => :user

  ################################################################################################################
  #
  # Attributes Accessible
  #
  ################################################################################################################
  attr_accessible :name, :organization, :team, :public
  attr_accessor :team
  
  ################################################################################################################
  #
  # Callbacks
  #
  ################################################################################################################
  after_create :add_default_stories
  after_save :assign_to_team
  before_save :add_hash_if_public
  
  ################################################################################################################
  #
  # Named Scopes
  #
  ################################################################################################################
  # Free projects are projects that don't have an organization assigned
  named_scope :free, :conditions => { :organization_id => 0 }

  ################################################################################################################
  #
  # Instance Methods
  #
  ################################################################################################################

  # returns an array with all the members of the project including guest members
  def users
    teams.collect {|team| team.users }.flatten + guest_members
  end

  def team_including(user)
    result = teams.first
    teams.each { |team| result = team if(team.users.include?(user)) }
    return result
  end
  
  def next_priority
    story = stories.first(:conditions => "priority != -1 ", :order => "priority ASC")
    last_priority = (!story.nil?) ? story.priority : nil
    return (last_priority > 10) ? last_priority - 10 : 0 if last_priority
    return 2000 if !last_priority
  end

  def next_realid
    if story = stories.first(:order => "realid DESC")
      number = story.realid[2..-1].to_i
      text = story.realid[0..1]
      number += 1
      id = (number < 10) ? "#{text}00#{number}" : "#{text}#{number}"
      id = "#{text}0#{number}" if (number >= 10 && number < 100)
      return id
    else 
      return initials + '001'
    end
  end
  
  def initials
    initials = ""
    words = name.split
    if words.size == 1
      if words.first.length > 2
        initials << words[0][0] << words[0][1]
      else
        initials << words[0][0] << words[0][0]
      end	
    else
      words.each do |word|
        initials << word[0]
      end
    end
  return initials.upcase[0..1]
  end
  
private
  # add_default_stories: this function is called when a new project is created, it adds the sample stories to it
  def add_default_stories
    stories.create(:name => "Sample Started Story", :size => 10, :description => "This is a sample story that is started, edit it to begin using this project")
    stories.first.start
    stories.create(:name => "Sample Not Started Story", :size => 10, :description => "This is a sample story that is not started, edit it to begin using this project")
    save
  end

  # Create the public hash for the project
  def add_hash_if_public
    self.public_hash = self.public? ? Digest::SHA1.hexdigest(self.name + Time.now.to_s) : nil
  end
  
  def assign_to_team
    if(team)
      self.teams.delete_all 
      self.teams << organization.teams.find(team)
    end
  end
end
