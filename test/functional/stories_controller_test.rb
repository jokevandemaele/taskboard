require File.dirname(__FILE__) + '/../test_helper'

class StoriesControllerTest < ActionController::TestCase
  context "If i'm a normal user" do
    setup do
      @user = Factory(:user)
    end

  end

  context "If i'm an organization admin" do
    setup do
      @organization = Factory(:organization)
      @user = Factory(:user)
      @mem = @organization.organization_memberships.build(:user => @user)
      @mem.admin = true
      @mem.save
    end
    
    should "admin the organization" do
      assert @user.organizations_administered.include?(@organization)
    end

  end
  
  context "If I'm an admin" do
    setup do
      @user = admin_user
    end
    
  end
end
