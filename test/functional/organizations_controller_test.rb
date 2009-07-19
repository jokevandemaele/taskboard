require 'test_helper'

class Admin::OrganizationsControllerTest < ActionController::TestCase
  ########################## Permissions tests ##########################
  test "index should be seen only all" do
    login_as_administrator
    get :index
    assert_response :ok
    
    login_as_organization_admin
    get :index
    assert_response :ok

    login_as_normal_user
    get :index
    assert_response :ok
  end

  test "new should be seen by administrator only" do
    login_as_administrator
    get :new
    assert_response :ok
    # Organization admin should be able to see new only if admins the current organization
    login_as_organization_admin
    get :new
    assert_response 302
  
    login_as_normal_user
    get :new
    assert_response 302
  end
  
  test "edit should be seen by administrator and organization admin" do
    login_as_administrator
    get :edit, :id => 1
    assert_response :ok
    
    login_as_organization_admin
    get :edit, :id => 1
    assert_response :ok
  
    login_as_normal_user
    get :edit, :id => 1
    assert_response 302
  end

  test "a system adminsitrator should be able CREATE, UPDATE and DELETE organizations" do
    login_as_administrator
    # CREATE organization
    post :create, :organization => { :name => 'Oxford University college' }
    assert_response :created
    assert Organization.find_by_name('Oxford University college')

    # UPDATE organization where admin belongs
    organization = organizations(:widmore_corporation)
    put :update, { :id => organization.id, :organization => { :name => 'Widmore Corporation..' } }
    assert_response :ok
    organization.reload
    assert_equal 'Widmore Corporation..', organization.name

    # UPDATE organization where admin doesn't belong
    org_notmine = Organization.find_by_name('Oxford University college')
    put :update, { :id => org_notmine.id, :organization => { :name => 'Oxford University college.' } }
    assert_response :ok
    org_notmine.reload
    assert_equal 'Oxford University college.', org_notmine.name
    
    # DELETE organization
    delete :destroy, { :id => org_notmine.id }
    assert_response :ok
    assert_nil Organization.find_by_name('Oxford University college.')
  end

  test "an organization admin should be able to UPDATE its organizations" do
    login_as_organization_admin
  
    # CREATE organization
    post :create, :organization => { :name => 'Oxford University college' }
    assert_response 302
    assert !Organization.find_by_name('Oxford University college')
    
    # UPDATE organization where admin belongs
    organization = organizations(:widmore_corporation)
    put :update, { :id => organization.id, :organization => { :name => 'Widmore Corporation.' } }
    assert_response :ok
    organization.reload
    assert_equal 'Widmore Corporation.', organization.name

    # UPDATE organization admin doesn't admin
    organization = organizations(:oceanic_six)
    put :update, { :id => organization.id, :organization => { :name => 'Kill them all.' } }
    assert_response 302
    organization.reload
    assert_not_equal 'Kill them all.', organization.name
    
    # DELETE organization
    delete :destroy, { :id => organization }
    assert_response 302
    assert Organization.find_by_name('Widmore Corporation.')
  end

  test "a normal user shouldn't be able to CREATE, UPDATE and DELETE teams to any organization" do
    login_as_normal_user
    
    # CREATE
    post :create, :organization => { :name => 'Oxford University college' }
    assert_response 302
    assert !Organization.find_by_name('Oxford University college')
    
    # UPDATE
    organization = organizations(:oceanic_six)
    put :update, { :id => organization.id, :organization => { :name => 'Kill them all.' } }
    assert_response 302
    organization.reload
    assert_not_equal 'Kill them all.', organization.name

    # DELETE
    delete :destroy, { :id => organization }
    assert_response 302
    assert Organization.find_by_name('Oceanic Six')
  end

  # test "an organization admin should be able to add & remove members for teams within its organizations" do
  #   login_as_organization_admin
  # 
  #   # ADD MEMBER with team and member belonging to organization
  #   post :add_member,{ :team => teams(:widmore_team), :member => members(:cwidmore) }
  #   assert_response :ok
  #   assert teams(:widmore_team).members.include?(members(:cwidmore))
  # 
  #   # ADD MEMBER with team belonging to organization
  #   post :add_member,{ :team => teams(:widmore_team), :member => members(:mdawson) }
  #   assert_response 302
  #   assert !teams(:widmore_team).members.include?(members(:mdawson))
  #   
  #   # ADD MEMBER with member belonging to organization
  #   post :add_member,{ :team => teams(:oceanic_six), :member => members(:clittleton) }
  #   assert_response 302
  #   assert !teams(:oceanic_six).members.include?(members(:clittleton))
  # 
  #   # ADD MEMBER with none belonging to organization
  #   post :add_member,{ :team => teams(:oceanic_six), :member => members(:mdawson) }
  #   assert_response 302
  #   assert !teams(:oceanic_six).members.include?(members(:mdawson))
  # 
  #   # REMOVE MEMBER with team and member belonging to organization
  #   post :remove_member,{ :team => teams(:widmore_team), :member => members(:cwidmore) }
  #   assert_response :ok
  #   assert !teams(:widmore_team).members.include?(members(:cwidmore))
  # 
  #   # REMOVE MEMBER with none belonging to organization
  #   post :remove_member,{ :team => teams(:oceanic_six), :member => members(:jshephard) }
  #   assert_response 302
  #   assert teams(:oceanic_six).members.include?(members(:jshephard))
  #   
  # end
  # 
end
