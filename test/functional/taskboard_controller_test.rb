require 'test_helper'

class TaskboardControllerTest < ActionController::TestCase
  # test "last project is set when accessing the taskboard" do
  #   login_as_organization_admin
  #   get :show, :id => projects(:find_the_island)
  #   assert_response :ok
  #   get :team, :id => teams(:widmore_team)
  #   assert_response :ok
  #   assert_select "div#menu_views" do |menu_views|
  #     assert_select "a" do |links|
  #       assert_equal "/taskboard/#{projects(:find_the_island).id}", links[0].attributes['href']
  #     end
  #   end
  # 
  #   get :show, :id => projects(:fake_planecrash)
  #   assert_response :ok
  #   get :team, :id => teams(:widmore_team)
  #   assert_response :ok
  #   assert_select "div#menu_views" do |menu_views|
  #     assert_select "a" do |links|
  #       assert_equal "/taskboard/#{projects(:fake_planecrash).id}", links[0].attributes['href'] 
  #     end
  #   end
  # 
  # end
  # 
  # ########################## Permissions tests ##########################
  # test "system administrator should be able to access any taskboard" do
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
  # test "organization administrator should be able to access only taskboards within its organization" do
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
  # test "normal users should be able to access only taskboards from projects they belong" do
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
  # end
  # 
  # context "If i'm not logged in" do
  #   context "And try to access as a guest with hash" do
  #     setup do
  #       @project = projects(:come_back_to_the_island)
  #       @project.public = true
  #       @project.save
  #       get :show, :id => @project.id, :public_hash => @project.public_hash
  #     end
  #     should_respond_with :ok
  #     should_assign_to(:project){ @project }
  #     should_render_template :show
  #   end
  #   
  # end
  # 
end
