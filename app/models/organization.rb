class Organization < ActiveRecord::Base
  has_many :projects
  has_and_belongs_to_many :members
end
