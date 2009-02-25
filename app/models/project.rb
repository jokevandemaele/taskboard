class Project < ActiveRecord::Base
  has_many :stories
  has_and_belongs_to_many :teams
  
  # members: returns an array with all the members of the project
  def members
    members = Array.new
    self.teams.each { |team| members.concat team.members }
    return members
  end
end
