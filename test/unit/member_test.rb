require 'test_helper'

class MemberTest < ActiveSupport::TestCase
  self.use_instantiated_fixtures = true
  fixtures :members

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
    assert_not_nil member.password
    assert member.save 
    assert_equal member, Member.authenticate("newmember2", "newpassword")
  end
  
  # Test the format of nametags
  def test_nametag_format
    assert_equal "CHARLIE", members(:cpace).formatted_nametag
    assert_equal "MICHAEL F", members(:mfaraday).formatted_nametag
  end
end
