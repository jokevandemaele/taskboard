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

  test "create with correct organization adds the member to that organization" do
    login_as_administrator
    post :create, { :member => {:name => 'Vincent', :username => 'vincent', :email => 'vincent@peta.org', :password => 'dog'}, :organization => organizations(:widmore_corporation).id }
    assert_response :created
    assert member = Member.find_by_name('Vincent')
    assert member.organizations.include?(organizations(:widmore_corporation))
  end
  
  test "create with picture adds picture correctly" do
    # HOW TO TEST THIS
  end
  
  test "create with wrong data shouldn't create anything and display form" do
    login_as_administrator
    post :create, { :member => {:name => 'Vincent', :username => 'cwidmore', :email => 'vincent@peta.org', :password => 'dog'}, :organization => organizations(:widmore_corporation).id }
    assert_response :bad_request
    assert !Member.find_by_name('Vincent')
  end

  test "update with empty password doesn't update it" do
    login_as_administrator
    put :update, { :id => 1, :member => { :name => 'Vincent', :username => 'vincent', :email => 'vincent@dharma.org', :password => ''} }
    assert_response :ok
    member = Member.find(1)
    assert_equal 'Vincent', member.name
    assert_equal 'vincent@dharma.org', member.email
    assert_equal Member.encrypt('test'), member.hashed_password
  end 

  test "update with wrong data shouldn't update anything and display form" do
    login_as_administrator
    put :update, { :id => 1, :member => { :name => 'Vincent', :username => 'cwidmore', :email => 'vincent@dharma.org', :password => 'a'} }
    assert_response :bad_request
    member = Member.find(1)
    assert_equal 'Daniel Faraday', member.name
    assert_equal Member.encrypt('test'), member.hashed_password
  end 

  ########################## Permissions tests ##########################
  test "index should be seen only by administrator" do
    login_as_administrator
    get :index
    assert_response :ok
    
    login_as_organization_admin
    get :index
    assert_response 302

    login_as_normal_user
    get :index
    assert_response 302
  end

  test "new should be seen by administrator and organization admin" do
    login_as_administrator
    get :new, :id => 1, :organization => 1
    assert_response :ok
    # administrator can call the form without an organization to select it from a drow down menu.
    get :new, :id => 1
    assert_response :ok
    # Organization admin should be able to see new only if admins the current organization
    login_as_organization_admin
    get :new, :organization => 1
    assert_response :ok
    get :new, :organization => 2
    assert_response 302

    login_as_normal_user
    get :new, :organization => 1
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
  
  test "a system adminsitrator should be able CREATE, UPDATE and DELETE people to any organization" do
    login_as_administrator
    # CREATE to organization where admin belongs
    post :create, { :member => {:name => 'Vincent', :username => 'vincent', :email => 'vincent@peta.org', :password => 'dog'}, :organization => organizations(:widmore_corporation).id }
    assert_response :created
    assert Member.find_by_name('Vincent')

    # CREATE to organization where admin doesn't belong
    post :create, { :member => {:name => 'Vincent', :username => 'vincent1', :email => 'vincent@peta.org', :password => 'dog'}, :organization => organizations(:dharma_initiative).id }
    assert_response :created
    assert Member.find_by_name('Vincent')

    # UPDATE from organization where admin belongs
    member = Member.find_by_name('Vincent')
    put :update, { :id => member.id, :member => { :name => 'Vincent', :username => 'vincent', :email => 'vincent@dharma.org', :password => 'dog'} }
    assert_response :ok
    member.reload
    assert_equal 'vincent@dharma.org', member.email
    assert_not_equal 'vincent@peta.org', member.email

    # UPDATE from organization where admin doesn't belong
    member = members(:cpace)
    put :update, { :id => member.id, :member => { :name => 'Vincent', :username => 'vincent2', :email => 'vincent@dharma.org', :password => 'dog'} }
    assert_response :ok
    member.reload
    assert_equal 'vincent@dharma.org', member.email
    assert_not_equal 'cpace@lost.com', member.email
    
    # DELETE from organization where admin belongs
    delete :destroy, { :id => member.id }
    assert_response :ok
    assert_nil Member.find_by_username('vincent2')

    # DELETE from organization where admin doesn't belong
    delete :destroy, { :id => members(:mdawson).id }
    assert_response :ok
    assert_nil Member.find_by_name('Michael Dawson')
  end

  test "an organization admin should be able CRUD people to my organization" do
    login_as_organization_admin

    # CREATE to organization where admin belongs
    post :create, { :member => {:name => 'Vincent', :username => 'vincent', :email => 'vincent@peta.org', :password => 'dog'}, :organization => organizations(:widmore_corporation).id }
    assert_response :created
    assert Member.find_by_name('Vincent')
    
    # UPDATE from organization where admin belongs
    member = Member.find_by_name('Vincent')
    put :update, { :id => member.id, :member => { :name => 'Vincent', :username => 'vincent', :email => 'vincent@dharma.org', :password => 'dog'} }
    assert_response :ok
    member.reload
    assert_equal 'vincent@dharma.org', member.email
    assert_not_equal 'vincent@peta.org', member.email
    
    # DELETE from organization where admin belongs
    delete :destroy, { :id => member.id }
    assert_response :ok
    assert_nil Member.find_by_name('Vincent')
  end

  test "an organization admin shouldn't be able CRUD people to another organization" do
    login_as_organization_admin
    
    # CREATE to organization where admin belongs
    response = post :create, { :member => {:name => 'Vincent', :username => 'vincent1', :email => 'vincent@peta.org', :password => 'dog'}, :organization => organizations(:dharma_initiative).id }
    assert_response 302
    assert !Member.find_by_name('Vincent')
    
    # UPDATE from organization where admin belongs
    member = members(:clittleton)
    put :update, { :id => member.id, :member => { :name => 'Vincent', :username => 'vincent', :email => 'clittleton@blo.org', :password => 'dog'} }
    assert_response 302
    member.reload
    assert_not_equal 'clittleton@blo.org', member.email
    
    # DELETE from organization where admin belongs
    delete :destroy, { :id => member.id }
    assert_response 302
    assert Member.find_by_name(member.name)
  end 

  test "a normal user shouldn't be able to CRUD people to any organization" do
    login_as_normal_user
    
    # CREATE to organization where admin belongs
    response = post :create, { :member => {:name => 'Vincent', :username => 'vincent1', :email => 'vincent@peta.org', :password => 'dog'}, :organization => organizations(:dharma_initiative).id }
    assert_response 302
    assert !Member.find_by_name('Vincent')
    
    # UPDATE from organization where admin belongs
    member = members(:clittleton)
    put :update, { :id => member.id, :member => { :name => 'Vincent', :username => 'vincent', :email => 'clittleton@blo.org', :password => 'dog'} }
    assert_response 302
    member.reload
    assert_not_equal 'clittleton@blo.org', member.email
    
    # DELETE from organization where admin belongs
    delete :destroy, { :id => member.id }
    assert_response 302
    assert Member.find_by_name(member.name)
    
  end

  
end
