class Task < ActiveRecord::Base
  belongs_to :story
  has_many :nametags
  has_many :statustags
end
