require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  fixtures :organizations

  test "an organization should be created with a default team and a default project" do
    organization = Organization.create(:name => 'Testing Inc.')
    assert_equal 1, organization.teams.size
    assert_equal 'Testing Inc. Team', organization.teams.first.name

    assert_equal 1, organization.projects.size
    assert_equal 'Testing Inc. Project', organization.projects.first.name

    assert_equal organization.projects.first.teams.first.name, organization.teams.first.name
    assert_equal organization.teams.first.projects.first.name, organization.projects.first.name
  end

  test "members_ordered_by_role works as expected" do
    organization = organizations(:widmore_corporation)
    
    admins = []
    org_admins = []
    normal = []
    organization.members.each do |member|
      normal << member if !member.admin? && !member.admins?(organization)
      org_admins << member if !member.admin? && member.admins?(organization)
      admins << member if member.admin?
    end
    expected_result = admins + org_admins + normal
    assert_equal expected_result, organization.members_ordered_by_role
  end

  test "teams_ordered_for_user should work as expected" do
    assert_equal [ teams(:widmore_team), teams(:planecrash_team), teams(:widmore_only_team)], organizations(:widmore_corporation).teams_ordered_for_member(members(:dfaraday))
    assert_equal [ teams(:planecrash_team), teams(:widmore_only_team), teams(:widmore_team)], organizations(:widmore_corporation).teams_ordered_for_member(members(:cwidmore))
  end

  test "projects_ordered_for_user should work as expected" do
    assert_equal [ projects(:find_the_island), projects(:fake_planecrash) ], organizations(:widmore_corporation).projects_ordered_for_member(members(:dfaraday))
    assert_equal [ projects(:fake_planecrash), projects(:find_the_island) ], organizations(:widmore_corporation).projects_ordered_for_member(members(:cwidmore))
  end
  
  test "guest_members should work" do
    team_membership = GuestTeamMembership.new(:member => members(:dfaraday), :project => projects(:do_weird_experiments), :team => teams(:dharma_team))
    assert team_membership.save
    assert organizations(:dharma_initiative).guest_members.include?(members(:dfaraday))
  end

end
