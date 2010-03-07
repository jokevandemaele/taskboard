require File.dirname(__FILE__) + '/../test_helper'

class OrganizationMembershipTest < ActiveSupport::TestCase
  context "OrganizationMembership" do
    ################################################################################################################
    #
    # Validations
    #
    ################################################################################################################
    should_validate_presence_of :user, :organization
    
    ################################################################################################################
    #
    # Associations
    #
    ################################################################################################################
    should_belong_to :organization
    should_belong_to :user
  end
  
  
  # test "a member created with admin privileges should keep them" do
  #   others = Organization.create(:name => 'The Others')
  #   one_john = Member.create(:name => 'John Locke', :username => 'jlocke', :password => 'secret', :email => 'jlocke@example.com', :new_organization => others.id)
  #   another_john = Member.create(:name => 'John Locke', :username => 'johnl', :password => 'secret', :email => 'johnl@example.com', :new_organization => others.id, :admin => true)
  # 
  #   assert one_john.admins?(others)
  #   assert another_john.admins?(others)
  # end
  # 
  # test "first member added to an organization should be given admin status" do
  #   others = Organization.create(:name => 'The Others')
  #   one_john = Member.create(:name => 'John Locke', :username => 'jlocke', :password => 'secret', :email => 'jlocke@example.com', :new_organization => others.id)
  #   another_john = Member.create(:name => 'John Locke', :username => 'johnl', :password => 'secret', :email => 'johnl@example.com', :new_organization => others.id)
  # 
  #   assert one_john.admins?(others)
  #   assert !another_john.admins?(others)
  # end
  # 
  # test "adminitered namescope works as expected" do
  #   assert_equal 1, members(:cwidmore).organization_memberships.administered.size
  #   assert_equal 0, members(:dfaraday).organization_memberships.administered.size
  # end
  # 
  # test "if only one team exists, a new member should be added to that team" do
  #   membership = OrganizationMembership.create(:member => members(:sjarrah), :organization => organizations(:dharma_initiative))
  #   assert membership.member.teams.include?(teams(:dharma_team))
  # end

end
