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
  
  test "if logging in as administrator sould see admin/organizations" do
    get "/logout"
    assert redirect?
    get "/login"
    assert_response :ok
    post '/login', {:member => {:username => 'clittleton', :password => 'test' }}
    assert_redirected_to :controller => "admin/organizations", :action => "index"
  end

  test "if logging in as organization admin sould see admin/organizations" do
    get "/logout"
    assert redirect?
    get "/login"
    assert_response :ok
    post '/login', {:member => {:username => 'cwidmore', :password => 'test' }}
    assert_redirected_to :controller => "admin/organizations", :action => "index"
  end

  test "if logging in as member with more than one project sould see admin/organizations" do
    get "/logout"
    assert redirect?
    get "/login"
    assert_response :ok
    post '/login', {:member => {:username => 'jshephard', :password => 'test' }}
    assert_redirected_to :controller => "admin/projects", :action => "index"
  end

end
