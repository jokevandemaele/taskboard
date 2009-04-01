class Task < ActiveRecord::Base
  belongs_to :story
  has_many :nametags, :dependent => :delete_all
  has_many :statustags, :dependent => :delete_all

  def remove_tags
    self.statustags.clear
    self.nametags.clear
  end
end
