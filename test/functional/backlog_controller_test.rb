require 'test_helper'

class BacklogControllerTest < ActionController::TestCase
  test "system administrator should be able to access any backlog" do
    login_as_administrator
    # A taskboard from a project in an organization the admin belongs and he's on a team
    get :show, :id => projects(:fake_plaincrash)
    assert_response :ok
    get :team, :id => teams(:widmore_team)
    assert_response :ok

    # A taskboard from a project in an organization the admin belongs and he's not on the team
    get :show, :id => projects(:find_the_island)
    assert_response :ok
    get :team, :id => teams(:widmore_team)
    assert_response :ok
    # A taskboard from a project in an organization the admin doesn't belong
    get :show, :id => projects(:come_back_to_the_island)
    assert_response :ok
    get :team, :id => teams(:oceanic_six)
    assert_response :ok
  end

  test "organization administrator should be able to access only backlogs within its organization" do
    login_as_organization_admin
    # A taskboard from a project in an organization the admin belongs and he's on a team
    get :show, :id => projects(:find_the_island)
    assert_response :ok
    get :team, :id => teams(:widmore_team)
    assert_response :ok
    # A taskboard from a project in an organization the admin belongs and he's not on the team
    get :show, :id => projects(:find_the_island)
    assert_response :ok
    get :team, :id => teams(:widmore_team)
    assert_response :ok
    # A taskboard from a project in an organization the admin doesn't administers
    get :show, :id => projects(:come_back_to_the_island)
    assert_response 302
    get :team, :id => teams(:oceanic_six)
    assert_response 302
  end
  
  test "normal users should be able to access only backlogs from projects and teams they belong" do
    login_as(members(:kausten))
    # A taskboard from a project where the user belongs
    get :show, :id => projects(:come_back_to_the_island)
    assert_response :ok
    get :team, :id => teams(:oceanic_six)
    assert_response :ok
    
    # A taskboard from a project where the user doesn't belong
    get :show, :id => projects(:find_the_island)
    assert_response 302
    get :team, :id => teams(:widmore_team)
    assert_response 302
    
  end
end
