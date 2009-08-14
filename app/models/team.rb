class Team < ActiveRecord::Base
  belongs_to :organization
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :members
  validates_uniqueness_of :name
end
