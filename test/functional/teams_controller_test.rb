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
  
  test "show team admin if i administer the organization of this project" do
    login_as_organization_admin
    get :index, :project => 1
    assert_select "div#members-list", :count => 1
  end

  test "show access denied if i don't administer the organization of this project" do
    login_as_normal_user
    get :index, :project => 1
    assert_redirected_to :controller => "admin/members", :action => :access_denied
  end

  test "show access denied if i don't administer the organization of this project but administer another" do
    login_as_organization_admin
    get :index, :project => 2
    assert_redirected_to :controller => "admin/members", :action => :access_denied
  end

end
