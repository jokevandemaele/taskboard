require File.dirname(__FILE__) + '/../test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  context "If i'm a normal user" do
    setup do
      @user = Factory(:user)
    end

  end

  context "If i'm an organization admin" do
    setup do
      @organization = Factory(:organization)
      @user = Factory(:user)
      @user.add_to_organization(@organization)
    end

    should "admin the organization" do
      assert @user.admins?(@organization)
    end

  end
  
  context "If I'm an admin" do
    setup do
      @user = admin_user
    end
    
  end
end
