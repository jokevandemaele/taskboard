require 'test_helper'

class Admin::MembersControllerTest < ActionController::TestCase
  test "if access denied is shown don't display the sidebar" do
    login_as_normal_user
    get :access_denied
    assert_select "p#access_denied", :count => 1
    assert_select "div#admin-sidebar", :count => 0
  end
  
  test "if access bug report logged in it should have permissions" do
    login_as_normal_user
    get :report_bug
    assert_select "div#reportbug"
  end
  
  # Permissions tests
  test "a system adminsitrator should CRUD people to any organization" do
    login_as_administrator

    # CREATE to organization where admin belongs
    post :create, { :member => {:name => 'Vincent', :username => 'vincent', :email => 'vincent@peta.org', :password => 'dog'}, :organization => organizations(:widmore_corporation).id }
    assert_response :created
    # READ from organization where admin belongs
    
    # UPDATE from organization where admin belongs
    # DELETE from organization where admin belongs

  end

  test "an organization admin should CRUD people to my organization" do
    login_as_organization_admin
  end

  test "an organization admin shouldn't CRUD people to another organization" do
    login_as_organization_admin
  end 

  test "a normal user shouldn't be able to CRUD people to any organization" do
    login_as_normal_user
  end

  
end
