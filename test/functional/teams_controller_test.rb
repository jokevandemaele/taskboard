require 'test_helper'

class Admin::TeamsControllerTest < ActionController::TestCase
  test "team index as sysadmin" do
    login_as_administrator
    get :index
    # A admin should see all projects
    assert_tag :tag => "select", :attributes => { :id => "project" }
    assert_select "select#project" do |elements|
      elements.each do |element|
        assert_select element, "option", Project.all.size
      end
    end
  end

  test "team index as normal user" do
    login_as_normal_user
    get :index
    # A normal user should not have access to admin/members
    assert_redirected_to :controller => "admin/members", :action => :access_denied
  end

  test "project dropdown as organization admin only shows organization projects" do
    login_as_organization_admin
    get :index
    assert_response :success
    # An organization admin should see only projects within its organization
    @organizations = current_member.organizations_administered
    @projects = Array.new
    @organizations.each do |organization|
      organization.projects.each {|project| @projects << project }
    end
    
    assert_select "select#project" do |elements|
      elements.each do |element|
        assert_select element, "option", @projects.size
      end
    end
  end

  #test "should get new" do
  #  get :new
  #  assert_response :success
  #end

  #test "should create team" do
  #  assert_difference('Team.count') do
  #    post :create, :team => { }
  #  end

  #  assert_redirected_to team_path(assigns(:team))
  #end

#  test "should show team" do
#    get :show, :id => teams(:one).id
#    assert_response :success
#  end

#  test "should get edit" do
#    get :edit, :id => teams(:one).id
#    assert_response :success
#  end

#  test "should update team" do
#    put :update, :id => teams(:one).id, :team => { }
#    assert_redirected_to team_path(assigns(:team))
#  end

#  test "should destroy team" do
#    assert_difference('Team.count', -1) do
#      delete :destroy, :id => teams(:one).id
#    end

#    assert_redirected_to teams_path
#  end
end
