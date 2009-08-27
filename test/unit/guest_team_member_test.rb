require 'test_helper'

class GuestTeamMembershipTest < ActiveSupport::TestCase
  fixtures :members, :projects, :teams

  test "create membership and all fields must be filled but teams" do
    team_membership = GuestTeamMembership.new(:member => members(:dfaraday), :project => projects(:do_weird_experiments))
    assert team_membership.save

    team_membership1 = GuestTeamMembership.new(:project => projects(:do_weird_experiments))
    assert !team_membership1.save

    team_membership2 = GuestTeamMembership.new(:member => members(:dfaraday))
    assert !team_membership2.save
  end

  test "do not allow to save a guest member if it is already on the project" do 
    team_membership = GuestTeamMembership.new(:member => members(:dfaraday), :project => projects(:do_weird_experiments))
    assert team_membership.save
    team_membership = GuestTeamMembership.new(:member => members(:dfaraday), :project => projects(:do_weird_experiments))
    assert !team_membership.save
  end

  test "do not allow to save a guest member if it already belongs to the organization" do 
    team_membership = GuestTeamMembership.new(:member => members(:dfaraday), :project => projects(:find_the_island))
    assert !team_membership.save
  end

end
