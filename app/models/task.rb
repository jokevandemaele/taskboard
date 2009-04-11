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
end
