class Role < ActiveRecord::Base
  # Relations
  has_and_belongs_to_many :members
  has_and_belongs_to_many :rights

  # Validations 
  validates_uniqueness_of :name
end
