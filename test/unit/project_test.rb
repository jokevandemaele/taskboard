require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  fixtures :projects, :members, :teams, :organizations

	test "every project should be created with two sample stories, one started and one not started" do
		project = Project.create(:name => "Find Mile's father", :organization => organizations(:widmore_corporation))
		assert_equal 2, project.stories.size
		assert_equal "Sample Started Story", project.stories.first.name
		assert_equal 2000, project.stories.first.priority
		assert_equal 10, project.stories.first.size
		assert project.stories.first.started?
		assert_equal "This is a sample story that is started, edit it to begin using this project", project.stories.first.description

		assert_equal "Sample Not Started Story", project.stories.second.name
		assert_equal 1990, project.stories.second.priority
		assert_equal 10, project.stories.second.size
		assert !project.stories.second.started?
		assert_equal "This is a sample story that is not started, edit it to begin using this project", project.stories.second.description
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
  
  test "next_priority" do
    project = Project.create(:name => "Find Mile's father", :organization => organizations(:widmore_corporation))
		assert_equal 1980, project.next_priority
		s = Story.create(:project => project, :realid => "AAB1112", :priority => 100)
		assert_equal 100, s.priority
		assert_equal 90, project.next_priority
		s = Story.create(:project => project, :realid => "AAB1122")
		s = Story.create(:project => project, :realid => "AAB1132", :priority => 28)
		s = Story.create(:project => project, :realid => "AAB1142")
		s = Story.create(:project => project, :realid => "AAB1152", :priority => 5)
		assert_equal 0, project.next_priority
		s = Story.create(:project => project, :realid => "AAB1162", :priority => -5)
		s = Story.create(:project => project, :realid => "AAB1172", :priority => 0)
		assert_equal 0, s.priority
  end
end
