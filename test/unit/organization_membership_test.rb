require 'test_helper'

class OrganizationMembershipTest < ActiveSupport::TestCase
  test "first member added to an organization should be given admin status" do
    others = Organization.create(:name => 'The Others')
    one_john = Member.create(:name => 'John Locke', :username => 'jlocke', :password => 'secret', :email => 'jlocke@example.com')
    another_john = Member.create(:name => 'John Locke', :username => 'johnl', :password => 'secret', :email => 'johnl@example.com')

    OrganizationMembership.create(:member => one_john, :organization => others)
    assert one_john.admins?(others)
    OrganizationMembership.create(:member => another_john, :organization => others)
    assert !another_john.admins?(others)
  end

  test "adminitered namescope works as expected" do
    assert_equal 1, members(:cwidmore).organization_memberships.administered.size
    assert_equal 0, members(:dfaraday).organization_memberships.administered.size
  end

  test "if only one team exists, a new member should be added to that team" do
    membership = OrganizationMembership.create(:member => members(:sjarrah), :organization => organizations(:dharma_initiative))
    assert membership.member.teams.include?(teams(:dharma_team))
  end

end
