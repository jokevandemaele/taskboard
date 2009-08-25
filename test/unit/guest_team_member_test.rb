require 'test_helper'

class GuestTeamMembershipTest < ActiveSupport::TestCase
  fixtures :members, :projects, :teams

  test "create membership and all fields must be filled" do
    team_membership = GuestTeamMembership.new(:member => members(:dfaraday), :project => projects(:do_weird_experiments), :team => teams(:dharma_team))
    assert team_membership.save

    team_membership1 = GuestTeamMembership.new(:project => projects(:do_weird_experiments), :team => teams(:dharma_team))
    assert !team_membership1.save

    team_membership2 = GuestTeamMembership.new(:member => members(:dfaraday), :team => teams(:dharma_team))
    assert !team_membership2.save
    
    team_membership3 = GuestTeamMembership.new(:member => members(:dfaraday), :project => projects(:do_weird_experiments))
    assert !team_membership3.save
  end

  
end
