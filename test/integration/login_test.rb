require File.dirname(__FILE__) + '/../test_helper'
class ProjectsRedirection < ActionController::IntegrationTest 
  context "When logging in" do
    setup do
      @organization = Factory(:organization)
      @admin = Factory(:user)
      @admin.add_to_organization(@organization)
      @organization.reload
      @user = Factory(:user)
      @user.add_to_organization(@organization)
    end

    context "having only one project" do
      setup do
        post '/user_sessions', {:user_session => {:login => @user.login, :password => 'test' }}, {:referer => 'http://www.example.com/login'}
      end
      
      should_redirect_to("The Project's Taskboard"){ project_taskboard_index_url(@organization.projects.first.to_param) }
    end

    context "having more than one project" do
      setup do
        @project = @organization.projects.build(:name => "Project 2")
        @team = @organization.teams.first
        @project.teams << @organization.teams.first
        @project.save
        post '/user_sessions', {:user_session => {:login => @user.login, :password => 'test' }}, {:referer => 'http://www.example.com/login'}
      end
      should_redirect_to("The dashboard"){ root_url }
    end

    context "having one project but being organization administrator" do
      setup do
        @om = @user.organization_memberships.first
        @om.admin = true
        @om.save
        @organization.reload
        @user.reload
        post '/user_sessions', {:user_session => {:login => @user.login, :password => 'test' }}, {:referer => 'http://www.example.com/login'}
      end

      should_redirect_to("The Project's Taskboard"){ root_url }
    end
  end
end
