require 'test_helper'

class OrganizationMembershipTest < ActiveSupport::TestCase
  test "adminitered namescope works as expected" do
    assert_equal 1, members(:cwidmore).organization_memberships.administered.size
    assert_equal 0, members(:dfaraday).organization_memberships.administered.size
  end

  test "if only one team exists, a new member should be added to that team" do
    membership = OrganizationMembership.create(:member => members(:sjarrah), :organization => organizations(:dharma_initiative))
    assert membership.member.teams.include?(teams(:dharma_team))
  end

end
