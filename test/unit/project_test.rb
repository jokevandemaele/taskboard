require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  fixtures :projects, :members, :teams, :organizations

	test "every project should be created with a sample story" do
		project = Project.create(:name => "Find Mile's father", :organization => organizations(:widmore_corporation))
		assert_equal 1, project.stories.size
		assert_equal "Sample Story", project.stories.first.name
		assert_equal 2000, project.stories.first.priority
		assert_equal 10, project.stories.first.size
		assert project.stories.first.started?
		assert_equal "This is a sample story, edit it to begin using this project", project.stories.first.description

	end

  test 'find the team containing a member or return the first' do 
    assert_equal teams(:widmore_team), projects(:find_the_island).team_including(members(:dfaraday))
    assert_equal projects(:find_the_island).teams.first, projects(:find_the_island).team_including(members(:kausten))
  end
  
  test "guest_members should work" do
    team_membership = GuestTeamMembership.new(:member => members(:dfaraday), :project => projects(:do_weird_experiments), :team => teams(:dharma_team))
    assert team_membership.save
    assert projects(:do_weird_experiments).guest_members.include?(members(:dfaraday))
  end

  test "members should return the team members + the guest members" do
    team_membership = GuestTeamMembership.new(:member => members(:dfaraday), :project => projects(:do_weird_experiments), :team => teams(:dharma_team))
    assert team_membership.save
    assert_equal projects(:do_weird_experiments).teams.first.members + projects(:do_weird_experiments).guest_members, projects(:do_weird_experiments).members
  end
  
end
