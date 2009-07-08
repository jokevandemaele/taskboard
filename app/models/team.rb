class Team < ActiveRecord::Base
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :members
  validates_uniqueness_of :name
end
