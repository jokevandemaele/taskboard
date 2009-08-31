require 'test_helper'

class MemberTest < ActiveSupport::TestCase
  fixtures :members, :organizations, :organization_memberships, :projects

  test "authentication works as expected" do
    # check that we can login with a valid user
    assert_equal members(:dfaraday), Member.authenticate("dfaraday","test")
    #wrong username
    assert_nil Member.authenticate("anything", "test")
    #wrong password
    assert_nil Member.authenticate("dfaraday", "wrongpass")
    #wrong login and pass
    assert_nil Member.authenticate("anything", "wrongpass")
  end

  test "password changing works as expected" do
    # check success
    assert_equal members(:dfaraday), Member.authenticate("dfaraday", "test")

    #change password
    members(:dfaraday).password = "newpassword"
    assert members(:dfaraday).save
    
    #new password works
    assert_equal members(:dfaraday), Member.authenticate("dfaraday", "newpassword")
    
    #old pasword doesn't work anymore
    assert_nil   Member.authenticate("dfaraday", "test")

    #change back again
    members(:dfaraday).password = "test"
    assert members(:dfaraday).save
    assert_equal members(:dfaraday), Member.authenticate("dfaraday", "test")
    assert_nil   Member.authenticate("dfaraday", "newpassword")
  end

  test "bad logins cannot be used" do
    #check we cant create a user with an invalid username
    member = Member.new
    member.password = "securepassword"
    member.name = "A New Member"
    member.email = "blo@blo.com"
    #too short
    member.username = "x"
    assert !member.save
    assert member.errors.invalid?('username')
    
    #too long
    member.username = "hugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhug"
    assert !member.save
    assert member.errors.invalid?('username')
    
    #empty
    member.username = ""
    assert !member.save
    assert member.errors.invalid?('username')
    
    #ok
    member.username = "okusername"
    assert member.save
    assert member.errors.empty?
  end
  test "bad emails cannot be used" do
    members(:dfaraday).email = "badmail"
    assert !members(:dfaraday).save
    members(:dfaraday).email = "badmail@baddomain"
    assert !members(:dfaraday).save
  end
  
  test "test_collision" do
    #check can't create new user with existing username
    member = Member.new
    
    member.username = "dfaraday"
    member.name = "Daniel Faraday"
    member.password = "okpassword"
    assert !member.save
  end
  
  test "create user" do
    #check create works and we can authenticate after creation
    member = Member.new
    member.username = "newmember"
    member.password = "okpassword"
    member.name = "A New User"
    member.email = "mail@blo.com"
    assert member.save
    #assert_equal member, Member.authenticate('newmember', 'okpassword')
    #member = Member.new(:username => "newmember2", :password => "newpassword", :name => "New Name" )
    #assert member.hashed_password == Member.encrypt('newpassword')
    #assert member.save 
    #assert_equal member, Member.authenticate("newmember2", "newpassword")
  end
  
  test "test the format of nametags" do
    assert_equal "CHARLIE", members(:cpace).formatted_nametag
    assert_equal "MICHAEL F", members(:mfaraday).formatted_nametag
  end
  
  test "add member to organization should work as expected" do
    # Daniel Faraday joins Dharma Initiative in the 5th Season, so, check that.
    dfaraday = members(:dfaraday)
    dfaraday.add_to_organization(organizations(:dharma_initiative).id)
    assert dfaraday.organizations.include?(organizations(:dharma_initiative))
  end
  
  test "organizations administered should give all the organizations the user admins" do
    # an organization administrator should have al the organizations it administers
    assert_equal 1, members(:cwidmore).organizations_administered.size
    # a normal user should not have any organization
    assert_equal 0, members(:dfaraday).organizations_administered.size
    # an admin should have the organizations
    assert_equal Organization.all.size, members(:clittleton).organizations_administered.size
  end
  
  test "admins return if i admin a certain organization" do
    assert members(:clittleton).admins?(organizations(:widmore_corporation))
    assert members(:clittleton).admins?(organizations(:dharma_initiative))
    assert members(:cwidmore).admins?(organizations(:widmore_corporation))
    assert !members(:dfaraday).admins?(organizations(:widmore_corporation))
  end
  
  test "admins_any_organization? works as expected" do
    assert members(:clittleton).admins_any_organization?
    assert members(:cwidmore).admins_any_organization?
    assert !members(:dfaraday).admins_any_organization?
  end

  test "member.administrators should return all the organization admins from the organizations the user belongs to" do
    admins = []
    members(:dfaraday).organizations.each do |organization|
      memberships = OrganizationMembership.all(:conditions => ["organization_id = ? AND admin = ?", organization, true])
      memberships.each {|memb| admins << memb.member }
    end
    assert_equal admins, members(:dfaraday).administrators
  end
  
  test "last project association works" do
    member = members(:dfaraday)
    member.last_project = projects(:find_the_island)
    assert_equal member.last_project, projects(:find_the_island)
  end
  
  test "projects show all the projects where the user is a member or guest member" do
    team_membership = GuestTeamMembership.new(:member => members(:dfaraday), :project => projects(:do_weird_experiments), :team => teams(:dharma_team))
    assert team_membership.save
    assert teams(:widmore_team).members << members(:dfaraday)
    assert_equal [projects(:do_weird_experiments)], members(:dfaraday).guest_projects
    assert_equal teams(:widmore_team).projects + [projects(:do_weird_experiments)], members(:dfaraday).projects
  end
end
