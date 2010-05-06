require File.dirname(__FILE__) + '/../test_helper'

class BacklogControllerTest < ActionController::TestCase
  context "Permissions" do
    should_require_belong_to_project_or_admin_on [:index]
    should_require_belong_to_project_or_admin_on_with_team_id [:team]
  end

  # context "If i'm a normal user" do
  #   setup do
  #     @user = Factory(:user)
  #   end
  # 
  # end
  # 
  # context "If i'm an organization admin" do
  #   setup do
  #     @organization = Factory(:organization)
  #     @user = Factory(:user)
  #     @mem = @organization.organization_memberships.build(:user => @user)
  #     @mem.admin = true
  #     @mem.save
  #   end
  #   
  #   should "admin the organization" do
  #     assert @user.organizations_administered.include?(@organization)
  #   end
  # 
  # end
  # 
  # context "If I'm an admin" do
  #   setup do
  #     @user = admin_user
  #   end
  #   
  # end

  # test "last project is set when accessing the taskboard" do
  #   login_as_organization_admin
  #   get :show, :id => projects(:find_the_island)
  #   assert_response :ok
  #   get :team, :id => teams(:widmore_team)
  #   assert_response :ok
  #   assert_select "div#menu_views" do |menu_views|
  #     assert_select "a" do |links|
  #       assert_equal "/backlog/#{projects(:find_the_island).id}", links[0].attributes['href']
  #     end
  #   end
  # 
  #   get :show, :id => projects(:fake_planecrash)
  #   assert_response :ok
  #   members(:cwidmore).reload
  #   members(:cwidmore).last_project
  #   get :team, :id => teams(:widmore_team)
  #   assert_response :ok
  #   assert_select "div#menu_views" do |menu_views|
  #     assert_select "a" do |links|
  #       assert_equal "/backlog/#{projects(:fake_planecrash).id}", links[0].attributes['href'] 
  #     end
  #   end
  # 
  # end
  # 
  # ########################## Permissions tests ##########################
  # test "system administrator should be able to access any backlog" do
  #   login_as_administrator
  #   # A taskboard from a project in an organization the admin belongs and he's on a team
  #   get :show, :id => projects(:fake_planecrash)
  #   assert_response :ok
  #   get :team, :id => teams(:widmore_team)
  #   assert_response :ok
  # 
  #   # A taskboard from a project in an organization the admin belongs and he's not on the team
  #   get :show, :id => projects(:find_the_island)
  #   assert_response :ok
  #   get :team, :id => teams(:widmore_team)
  #   assert_response :ok
  #   # A taskboard from a project in an organization the admin doesn't belong
  #   get :show, :id => projects(:come_back_to_the_island)
  #   assert_response :ok
  #   get :team, :id => teams(:oceanic_six)
  #   assert_response :ok
  # end
  # 
  # test "organization administrator should be able to access only backlogs within its organization" do
  #   login_as_organization_admin
  #   # A taskboard from a project in an organization the admin belongs and he's on a team
  #   get :show, :id => projects(:find_the_island)
  #   assert_response :ok
  #   get :team, :id => teams(:widmore_team)
  #   assert_response :ok
  #   # A taskboard from a project in an organization the admin belongs and he's not on the team
  #   get :show, :id => projects(:find_the_island)
  #   assert_response :ok
  #   get :team, :id => teams(:widmore_team)
  #   assert_response :ok
  #   # A taskboard from a project in an organization the admin doesn't administers
  #   get :show, :id => projects(:come_back_to_the_island)
  #   assert_response 302
  #   get :team, :id => teams(:oceanic_six)
  #   assert_response 302
  # end
  # 
  # test "normal users should be able to access only backlogs from projects and teams they belong" do
  #   login_as(members(:kausten))
  #   # A taskboard from a project where the user belongs
  #   get :show, :id => projects(:come_back_to_the_island)
  #   assert_response :ok
  #   get :team, :id => teams(:oceanic_six)
  #   assert_response :ok
  #   
  #   # A taskboard from a project where the user doesn't belong
  #   get :show, :id => projects(:find_the_island)
  #   assert_response 302
  #   get :team, :id => teams(:widmore_team)
  #   assert_response 302
  #   
  # end
end
