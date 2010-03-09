require File.dirname(__FILE__) + '/../test_helper'

class UserMailerTest < ActionMailer::TestCase
  context "UserMailerTest" do
    setup do
      @user = Factory.build(:user)
      @user.new_organization = Factory(:organization)
      @user.save
      ActionMailer::Base.deliveries.clear
    end

    context "#create" do
      setup do
        @response = UserMailer.deliver_create(@user)
      end
      should "send the email" do
        assert !ActionMailer::Base.deliveries.empty? 
      end
      should "have the correct subject" do
        assert_equal 'Welcome to the Agilar Taskboard!', @response.subject
      end
      should "have the correct receiver" do
        assert_equal [@user.email], @response.to
      end
      should "have the correct body" do
        assert_match /#{@user.login}/, @response.body
        assert_match /test/, @response.body
      end
    end
    
    context "#add_guest_to_projects" do
      setup do
        @projects = [ Factory(:project), Factory(:project) ]
        @response = UserMailer.deliver_add_guest_to_projects(@user, 'Charles Widmore', @projects)
      end
      should "send the email" do
        assert !ActionMailer::Base.deliveries.empty? 
      end
      should "have the correct subject" do
        assert_equal 'You have been added as a guest member', @response.subject
      end
      should "have the correct receiver" do
        assert_equal [@user.email], @response.to
      end
      should "have the correct body" do
        assert_match 'Charles Widmore', @response.body
        assert_match @projects[0].name, @response.body
        assert_match @projects[1].name, @response.body
      end
    end
  end
end
