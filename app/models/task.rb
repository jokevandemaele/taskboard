class Task < ActiveRecord::Base
  belongs_to :story
  has_many :nametags
  has_many :statustags

  def remove_tags
    self.statustags.each { |tag| tag.destroy }
    self.nametags.each { |tag| tag.destroy }
  end
end
