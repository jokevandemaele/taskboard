require 'test_helper'
class ProjectsRedirection < ActionController::IntegrationTest 

  test "index, if logging in as normal user and have only one project, i should see the taskboard" do
    get "/login"
    assert_response :ok
    post '/login', {:member => {:username => 'jburke', :password => 'test' }}, {:referer => 'http://www.example.com/login'}
    assert redirect?
    follow_redirect!
    assert_select "div#menu", :count => 1
  end
end
