require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase
  context "Permissions" do
    # should_require_admin_on :invite
    should_require_no_user_on [:new, :create]
    should_require_organization_admin_on [ :new, :create, :destroy, :toggle_admin ]
    should_require_user_on [ :edit, :update, :destroy ]
    should_require_own_account_on [ :edit, :update, :destroy ]
  end
  
  
  # ----------------------------------------------------------------------------------------------------------------
  # Routes
  # ----------------------------------------------------------------------------------------------------------------
  context "Users Routes" do
    # Organization administrators are able to create users into their organization and remove them from the org.
    # No permission to edit the user
    should_route :get, "/organizations/1/users/new", :action => :new, :organization_id => 1
    should_route :post, "/organizations/1/users", :action => :create, :organization_id => 1
    should_route :delete, "/organizations/1/users/2", :action => :destroy, :id => 2, :organization_id => 1
    # should_route :get, "/organizations/1/users/invite", :action => :invite, :organization_id => 1
    should_route :post, "/organizations/1/users/2/toggle_admin", :action => :toggle_admin, :id => 2, :organization_id => 1
    
    should_route :get, "/users/new", :action => :new
    should_route :post, "/users", :action => :create
    should_route :get, "/users/2/edit", :action => :edit, :id => 2
    should_route :put, "/users/2", :action => :update, :id => 2
    should_route :delete, "/users/2", :action => :destroy, :id => 2
  end
  

  # ----------------------------------------------------------------------------------------------------------------
  # Not logged User
  # ----------------------------------------------------------------------------------------------------------------
  context "If I'm an unlogged user" do
    context "and do GET to :new" do
      setup do
        get :new
      end
      # should_respond_with :ok
      # should_assign_to(:user)
      # should_render_template :new
    end

    context "and do POST to :create with correct data" do
      setup do
        post :create, :user => { :name => "A User", :login => "user", :email => "email@taskboard.com", :password => "test", :password_confirmation => "test"}
      end
      should_set_the_flash_to(/Welcome to the Agilar Taskboard!/)
      should_redirect_to("the root page"){ root_url }
      should "create the user" do
        assert User.find_by_login('user')
      end
    end

    context "and do POST to :create with incorrect data" do
      setup do
        post :create, :user => { }
      end
      # should_assign_to(:user)
      should_render_template :new
    end
  end
  
  # ----------------------------------------------------------------------------------------------------------------
  # Normal User
  # ----------------------------------------------------------------------------------------------------------------
  context "If I'm a normal user" do
    setup do
      @organization = Factory(:organization)
      @user = Factory(:user)
    end
    
    context "and do GET to :edit with my id" do
      setup do
        get :edit, :id => @user.to_param
      end
      should_respond_with :ok
      should_assign_to(:user){@user}
      should_render_template :edit
    end
    
    context "and do PUT to :update.json with correct data and with my id" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        put :update, :id => @user.to_param, :user => { :name => "The User", :email => "my_email@taskboard.com"}
        assert @user.reload
      end
      should_respond_with :ok
      should_not_set_the_flash
      should_assign_to(:user){ @user }

      should "update the user" do
        assert_equal "The User", @user.name
        assert_equal "my_email@taskboard.com", @user.email
      end

      should "return the user json" do
        assert_match @user.to_json, @response.body
      end
    end

    context "and do PUT to :update.json with incorrect data and with my id" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        put :update, :id => @user.to_param, :user => { :name => "", :email => ""}
      end
      should_respond_with :precondition_failed
      should_not_set_the_flash
      should_assign_to(:user){ @user }
      
      should "return the errors json" do
        assert_match /can't be blank/, @response.body
      end
    end

    
    context "and do DELETE to :destroy.json with my id" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        delete :destroy, :id => @user.to_param
      end
      should_respond_with :ok
      should_not_set_the_flash
      should_assign_to(:user){ @user }
      
      should "destroy the user" do
        assert_raise ActiveRecord::RecordNotFound do
            @user.reload
        end
      end
    end
    
  end
  
  # ----------------------------------------------------------------------------------------------------------------
  # Organization Admin
  # ----------------------------------------------------------------------------------------------------------------
  context "If I'm an organization admin" do
    setup do
      @organization = Factory(:organization)
      @user = Factory(:user)
      @user.add_to_organization(@organization)
      @organization.reload
    end

    should "admin the organization" do
      assert @user.admins?(@organization)
    end
    
    context "and do GET to :new" do
      setup do
        get :new, :organization_id => @organization.to_param
      end
      should_respond_with :ok
      should_assign_to(:user)
      should_render_template :new
    end
    
    context "and do POST to :create with correct data" do
      setup do
        post :create, :user => { :name => "A User", :login => "a_user", :email => "email@taskboard.com", :password => "test", :password_confirmation => "test"}, :organization_id => @organization.to_param
        @a_user = User.find_by_login('a_user')
      end
      should_respond_with(:created)
      should_assign_to(:user)

      should "create the user" do
        assert @a_user
      end
      
      should "add the user to the organization" do
        @organization.reload
        assert @organization.users.include?(@a_user)
      end
      
      should "return the user id in the body" do
        assert_match /id/, @response.body
      end

      should "return the organization in the body" do
        assert_match /organization/, @response.body
      end
    end
    
    context "and do POST to :create with incorrect data" do
      setup do
        post :create, :user => { }, :organization_id => @organization.to_param
      end
      should_assign_to(:user)
      should_respond_with :precondition_failed
      should "return the errors in json" do
        assert_match "can't be blank", @response.body
      end
    end
    
    context "and do DELETE to :destroy.json with other organization member id and my organization's id" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        @a_user = Factory(:user)
        @a_user.add_to_organization(@organization)
        delete :destroy, :id => @a_user.to_param, :organization_id => @organization.id
      end
      should_respond_with :ok
      should_not_set_the_flash
      should_assign_to(:user){ @a_user }
      
      should "remove the user from the organization" do
        assert !@organization.users.include?(@a_user)
      end
      
      should "not destroy the user" do
        assert @a_user.reload
      end
    end
    
    context "and do POST to :toggle_admin" do
      setup do
        @future_admin = Factory(:user)
        @future_admin.add_to_organization(@organization)
        assert !@future_admin.admins?(@organization)
        post :toggle_admin, :organization_id => @organization.to_param, :id => @future_admin.to_param
      end
      should_respond_with :ok
      should_assign_to(:organization){ @organization}
      should_assign_to(:user){ @future_admin }
      should "make the user admin" do
        @future_admin.reload
        assert @future_admin.admins?(@organization)
      end
      
      context "and do it again" do
        setup do
          post :toggle_admin, :organization_id => @organization.to_param, :id => @future_admin.to_param
        end
        should_respond_with :ok
        should_assign_to(:organization){ @organization}
        should_assign_to(:user){ @future_admin }
        should "make the user admin" do
          @future_admin.reload
          assert !@future_admin.admins?(@organization)
        end
      end
      
    end

    context "and do POST to :toggle_admin with my own id" do
      setup do
        post :toggle_admin, :organization_id => @organization.to_param, :id => @user.to_param
      end
      should_set_the_flash_to("Access Denied")
      should_redirect_to("the root url"){ root_url }
    end

    context "and do POST to :toggle_admin with a user that is not from my organization" do
      setup do
        @future_admin = Factory(:user)
        @organization1 = Factory(:organization)
        @future_admin.add_to_organization(@organization1)
        post :toggle_admin, :organization_id => @organization1.to_param, :id => @future_admin.to_param
      end
      should_set_the_flash_to("Access Denied")
      should_redirect_to("the root url"){ root_url }
    end
    
    context "and do GET to :show an organization I belong to" do
      setup do
        get :show, :id => @user.to_param, :organization_id => @organization.to_param
      end
      should_respond_with :ok
      should_assign_to(:organization){ @organization }
      should_assign_to(:user){ @user }
      should_render_template :show
    end

    context "and do GET to :show an organization I don't belong to" do
      setup do
        @organization1 = Factory(:organization)
        @user1 = Factory(:user)
        @user1.add_to_organization(@organization)
        get :show, :id => @user1.to_param, :organization_id => @organization1.to_param
      end
      should_set_the_flash_to("Access Denied")
      should_redirect_to("the root url"){ root_url }
    end    
    
  end

  # ----------------------------------------------------------------------------------------------------------------
  # System Admin
  # ----------------------------------------------------------------------------------------------------------------
  context "If I'm an admin" do
    setup do
      @organization = Factory(:organization)
      @user = admin_user
    end
    
    context "and do GET to :new" do
      setup do
        get :new, :organization_id => @organization.to_param
      end
      should_respond_with :ok
      should_assign_to(:user)
      should_render_template :new
    end
    
    context "and do POST to :create with correct data" do
      setup do
        post :create, :user => { :name => "A User", :login => "user", :email => "email@taskboard.com", :password => "test", :password_confirmation => "test"}, :organization_id => @organization.to_param
      end
      should_respond_with :created
      should_assign_to(:user)
      should "create the user" do
        assert User.find_by_login('user')
      end
      should "return the user id in the body" do
        assert_match /id/, @response.body
      end

      should "return the organization in the body" do
        assert_match /organization/, @response.body
      end
    end
    
    context "and do POST to :create with incorrect data" do
      setup do
        post :create, :user => { }, :organization_id => @organization.to_param
      end
      should_assign_to(:user)
      should_respond_with :precondition_failed
      should "return the errors in json" do
        assert_match "can't be blank", @response.body
      end
    end
    
    context "and do GET to :edit with other's id" do
      setup do
        @user1 = Factory(:user)
        get :edit, :id => @user1.to_param
      end
      should_respond_with :ok
      should_assign_to(:user){@user1}
      should_render_template :edit
    end
    
    context "and do PUT to :update.json with correct data and with other's id" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        @user1 = Factory(:user)
        put :update, :id => @user1.to_param, :user => { :name => "The User", :email => "my_email@taskboard.com"}
        assert @user1.reload
      end
      should_respond_with :ok
      should_not_set_the_flash
      should_assign_to(:user){ @user1 }

      should "update the user" do
        assert_equal "The User", @user1.name
        assert_equal "my_email@taskboard.com", @user1.email
      end

      should "return the user json" do
        assert_match @user1.to_json, @response.body
      end
    end
    
    context "and do POST to :toggle_admin" do
      setup do
        @future_admin = Factory(:user)
        @future_admin.add_to_organization(@organization)
        @om = @future_admin.organization_memberships.first
        @om.admin = false
        @om.save
        assert !@future_admin.admins?(@organization)
        post :toggle_admin, :organization_id => @organization.to_param, :id => @future_admin.to_param
      end
      should_respond_with :ok
      should_assign_to(:organization){ @organization}
      should_assign_to(:user){ @future_admin }
      should "make the user admin" do
        @future_admin.reload
        assert @future_admin.admins?(@organization)
      end
    end

    context "and do GET to :show an organization I belong to" do
      setup do
        get :show, :id => @user.to_param, :organization_id => @organization.to_param
      end
      should_respond_with :ok
      should_assign_to(:organization){ @organization }
      should_assign_to(:user){ @user }
      should_render_template :show
    end

    context "and do GET to :show an organization I don't belong to" do
      setup do
        @organization1 = Factory(:organization)
        @user1 = Factory(:user)
        @user1.add_to_organization(@organization)
        get :show, :id => @user1.to_param, :organization_id => @organization1.to_param
      end
      should_respond_with :ok
      should_assign_to(:organization){ @organization1 }
      should_assign_to(:user){ @user1 }
      should_render_template :show
    end    
  end
end
