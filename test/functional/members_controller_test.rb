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
  test "an organization admin should be able to add a user to that organization" do
    login_as_organization_admin
    post :create, :member => {:name => 'Vincent', :username => 'vincent', :password => 'dog'}
    assert_response :bad_request
    user = Member.find_by_name('Vincent')
    assert !user
    post :create, :member => {:name => 'Vincent', :username => 'vincent', :email => 'vincent@peta.org', :password => 'dog'}
    assert_response :created
    user = Member.find_by_name('Vincent')
    assert user
  end
  
end
