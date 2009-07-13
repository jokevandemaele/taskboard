require 'test_helper'

class Admin::ProjectsControllerTest < ActionController::TestCase
  test "index, if logged in as admin i should see all projects" do
    login_as_administrator
    get :index
    assert_select "div.project-container", :count => Project.all.size
  end

  test "index, if logged in as organization admin i should see all projects within the organization" do
    login_as_organization_admin
    get :index

    expected_projects = []
    members(:cwidmore).organizations_administered.each do |organization|
      expected_projects << organization.projects
    end
    assert_select "div.project-container", :count => expected_projects.size
  end

  test "index, if logged in as organization admin i should see the projects i'm in with color" do
    login_as_organization_admin
  end

  test "index, if logged in as organization admin i should see the projects i'm not in with grey" do
    login_as_organization_admin
  end

  test "index, if logged in as normal user and have only one project, i should be redirected to its taskboard" do
    login_as_normal_user
    get :index
    assert_redirected_to :controller => :taskboard, :action => :show, :id => members(:dfaraday).projects.first.id
  end

  test "index, if logged in as normal user and have more than one project, i should see the list" do
    login_as(members(:jshephard))
    get :index
    assert_select "div.project-container", :count => members(:jshephard).projects.size
  end

  test "new, if logged as admin and do a get request i should not see the form" do
    login_as_administrator
  end

  test "new, if logged as admin and do an Ajax request i should see the form" do
    login_as_administrator
  end

  test "new, if logged as admin and do an Ajax request i should see all the organizations the form" do
    login_as_administrator
  end

  test "new, if logged as organization admin and do a get request i should not see the form" do
    login_as_organization_admin
  end

  test "new, if logged as organization admin and do an Ajax request i should see the form only if i admin an organization" do
    login_as_organization_admin
  end

  test "new, if logged as organization admin and do an Ajax request i should see only my administered organization in the form" do
    login_as_organization_admin
  end

  test "new, if logged as a normal user and do a get request i should get access denied" do
    login_as_normal_user
  end

  test "new, if logged as a normal user and do an Ajax request i should get access denied" do
    login_as_normal_user
  end

  test "edit" do
  end
  
  test "create" do
  end
  
  test "update" do
  end
  
  test "show" do
  end

end
