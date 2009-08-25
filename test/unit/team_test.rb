require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  fixtures :organizations, :teams, :members
  
  test "a team should be able to be assigned to an organization" do
    team = Team.new(:name => "Dharma Initiative")
    team.organization = organizations(:dharma_initiative)
    team.save
  end

end
