require File.dirname(__FILE__) + '/../test_helper'

class OrganizationsControllerTest < ActionController::TestCase
  context "Permissions" do
    should_require_user_on [:index]
    should_require_organization_admin_on_for_organizations_controller [ :edit, :update, :destroy ]
    should_require_admin_on [:new, :create]
  end
  # ----------------------------------------------------------------------------------------------------------------
  # Routes
  # ----------------------------------------------------------------------------------------------------------------
  context "Organization Routes" do
    should_route :get, "/organizations", :action => :index
    should_route :get, "/organizations/new", :action => :new
    should_route :post, "/organizations", :action => :create
    should_route :get, "/organizations/1/edit", :action => :edit, :id => 1
    should_route :put, "/organizations/1", :action => :update, :id => 1
    should_route :delete, "/organizations/1", :action => :destroy, :id => 1
  end
  
  # ----------------------------------------------------------------------------------------------------------------
  # Normal User
  # ----------------------------------------------------------------------------------------------------------------
  context "If i'm a normal user" do
    setup do
      @organization = Factory(:organization)
      @user = Factory(:user)
      @user.add_to_organization(@organization)
    end
    
    context "and do GET to :index" do
      setup do
        get :index
      end
      should_respond_with :ok
      should_not_set_the_flash
      should_assign_to(:organizations){ @user.organizations }
      should_render_template :index
    end
  end

  # ----------------------------------------------------------------------------------------------------------------
  # Organization Admin
  # ----------------------------------------------------------------------------------------------------------------
  context "If i'm an organization admin" do
    setup do
      @organization = Factory(:organization)
      @user = Factory(:user)
      @user.add_to_organization(@organization)
    end

    should "admin the organization" do
      assert @user.admins?(@organization)
    end

    context "and do GET to :index" do
      setup do
        get :index
      end
      should_respond_with :ok
      should_not_set_the_flash
      should_assign_to(:organizations){ @user.organizations }
      should_render_template :index
    end

    context "and do GET to :edit" do
      setup do
        get :edit, :id => @organization.to_param
      end
      should_respond_with :ok
      should_not_set_the_flash
      should_assign_to(:organization)
      should_render_template :edit
    end
    
    context "and do a PUT to :update.json with correct data" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        put :update, :id => @organization.to_param, :organization => { :name => "Organization 2" }
      end
      should_respond_with :ok
      should_not_set_the_flash

      should "update the organization" do
        assert !!Organization.find_by_name("Organization 2")
      end
      
      should "return the organization json" do
        assert_match Organization.find_by_name("Organization 2").to_json, @response.body
      end
    end

    context "and do a PUT to :update.json with incorrect data" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        put :update, :id => @organization.to_param, :organization => { :name => "" }
      end
      should_respond_with :precondition_failed
      should_not_set_the_flash

      should "return the errors json" do
        assert_match /can't be blank/, @response.body
      end
    end
    
    context "and do DELETE to :destroy.json" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        delete :destroy, :id => @organization.to_param
      end
      should_respond_with :ok
      should_not_set_the_flash
      
      should "destroy the organization" do
        assert_raise ActiveRecord::RecordNotFound do
            @organization.reload
        end
      end
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
    
    context "and do GET to :index" do
      setup do
        get :index
      end
      should_respond_with :ok
      should_not_set_the_flash
      should_assign_to(:organizations){ Organization.all }
      should_render_template :index
    end
    
    context "and do GET to :new" do
      setup do
        get :new
      end
      should_respond_with :ok
      should_not_set_the_flash
      should_assign_to(:organization)
      should_render_template :new
    end
    
    context "and do a POST to :create.json with correct data" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        post :create, :organization => { :name => "Organization" }
      end
      should_respond_with :created
      should_not_set_the_flash

      should "create the organization" do
        assert !!Organization.find_by_name("Organization")
      end
      
      should "return the organization json" do
        assert_match Organization.find_by_name("Organization").to_json, @response.body
      end
    end

    context "and do POST to :create.json with incorrect data" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        post :create, :organization => {}
      end
      should_respond_with :precondition_failed
      should_not_set_the_flash

      should "return the errors json" do
        assert_match /can't be blank/, @response.body
      end
    end
    
    context "and do GET to :edit" do
      setup do
        get :edit, :id => @organization.to_param
      end
      should_respond_with :ok
      should_not_set_the_flash
      should_assign_to(:organization)
      should_render_template :edit
    end
    
    context "and do a PUT to :update.json with correct data" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        put :update, :id => @organization.to_param, :organization => { :name => "Organization 2" }
      end
      should_respond_with :ok
      should_not_set_the_flash

      should "update the organization" do
        assert !!Organization.find_by_name("Organization 2")
      end
      
      should "return the organization json" do
        assert_match Organization.find_by_name("Organization 2").to_json, @response.body
      end
    end
    
    context "and do a PUT to :update.json with incorrect data" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        put :update, :id => @organization.to_param, :organization => { :name => "" }
      end
      should_respond_with :precondition_failed
      should_not_set_the_flash

      should "return the errors json" do
        assert_match /can't be blank/, @response.body
      end
    end
    
  end
  
end
