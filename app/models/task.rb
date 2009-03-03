class Task < ActiveRecord::Base
  belongs_to :story
  has_many :nametags, :dependent => :delete_all
  has_many :statustags, :dependent => :delete_all

  def remove_tags
    self.statustags.each { |tag| tag.destroy }
    self.nametags.each { |tag| tag.destroy }
  end
end
