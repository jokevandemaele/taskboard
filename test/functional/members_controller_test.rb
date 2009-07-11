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
    response = get :report_bug
    assert_select "div#reportbug"
  end
end
