require 'test_helper'

class MemberTest < ActiveSupport::TestCase
  self.use_instantiated_fixtures = true
  fixtures :members, :organizations

  # Test authentication.
  def test_auth
    # check that we can login with a valid user
    assert_equal @dfaraday, Member.authenticate("dfaraday","test")
    #wrong username
    assert_nil Member.authenticate("anything", "test")
    #wrong password
    assert_nil Member.authenticate("dfaraday", "wrongpass")
    #wrong login and pass
    assert_nil Member.authenticate("anything", "wrongpass")
  end

  # Test that changing password works.
  def test_passwordchange
    # check success
    assert_equal @dfaraday, Member.authenticate("dfaraday", "test")
    #change password
    @dfaraday.password = "newpassword"
    assert @dfaraday.save
    #new password works
    assert_equal @dfaraday, Member.authenticate("dfaraday", "newpassword")
    #old pasword doesn't work anymore
    assert_nil   Member.authenticate("dfaraday", "test")
    #change back again
    @dfaraday.password = "test"
    assert @dfaraday.save
    assert_equal @dfaraday, Member.authenticate("dfaraday", "test")
    assert_nil   Member.authenticate("dfaraday", "newpassword")
  end

  def test_bad_logins
    #check we cant create a user with an invalid username
    member = Member.new
    member.password = "securepassword"
    member.name = "A New Member"
    
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
 
  def test_collision
    #check can't create new user with existing username
    member = Member.new
    
    member.username = "dfaraday"
    member.name = "Daniel Faraday"
    member.password = "okpassword"
    assert !member.save
  end
  
  def test_create
    #check create works and we can authenticate after creation
    member = Member.new
    member.username = "newmember"
    member.password = "okpassword"
    member.name = "A New User"
    assert member.save
    assert_equal member, Member.authenticate('newmember', 'okpassword')
    member = Member.new(:username => "newmember2", :password => "newpassword", :name => "New Name" )
    assert member.hashed_password == Member.encrypt('newpassword')
    assert member.save 
    assert_equal member, Member.authenticate("newmember2", "newpassword")
  end
  
  # Test the format of nametags
  def test_nametag_format
    assert_equal "CHARLIE", members(:cpace).formatted_nametag
    assert_equal "MICHAEL F", members(:mfaraday).formatted_nametag
  end
  
  test "add member to organization should work as expected" do
    # Daniel Faraday joins Dharma initiative in the 5th Season, so, check that.
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
end
