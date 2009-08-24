require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  fixtures :projects, :members, :teams
  test 'find the team containing a member or return the first' do 
    assert_equal teams(:widmore_team), projects(:find_the_island).team_including(members(:dfaraday))
    assert_equal projects(:find_the_island).teams.first, projects(:find_the_island).team_including(members(:kausten))
  end
end
