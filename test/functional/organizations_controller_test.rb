require File.dirname(__FILE__) + '/../test_helper'

class OrganizationsControllerTest < ActionController::TestCase
  should_require_user_on [:index]
  #should_require_organization_admin_on [:edit, :update, :destroy]
  should_require_admin_on [:new, :create]

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
    end
  end

  # ----------------------------------------------------------------------------------------------------------------
  # Organization Admin
  # ----------------------------------------------------------------------------------------------------------------
  context "If i'm an organization admin" do
    setup do
      @organization = Factory(:organization)
      @user = Factory(:user)
      @mem = @organization.organization_memberships.build(:user => @user)
      @mem.admin = true
      @mem.save
    end
    
    should "admin the organization" do
      assert @user.organizations_administered.include?(@organization)
    end

    context "and do GET to :index" do
      setup do
        get :index
      end
      should_respond_with :ok
      should_not_set_the_flash
      should_assign_to(:organizations){ @user.organizations }
    end

  end

  # ----------------------------------------------------------------------------------------------------------------
  # System Admin
  # ----------------------------------------------------------------------------------------------------------------
  context "If I'm an admin" do
    setup do
      Factory(:organization)
      Factory(:organization)
      Factory(:organization)
      @user = admin_user
    end
    
    context "and do GET to :index" do
      setup do
        get :index
      end
      should_respond_with :ok
      should_not_set_the_flash
      should_assign_to(:organizations){ Organization.all }
    end
    
    context "and do GET to :new" do
      setup do
        get :new
      end
      should_respond_with :ok
      should_not_set_the_flash
      should_assign_to(:organization)
    end
    
    context "and do POST to :create with correct data" do
      setup do
        post :create, :organization => { :name => "Organization" }
      end
      should_set_the_flash_to("Organization created.")
      should_assign_to(:organization)
      should "create the organization" do
        assert !!Organization.find_by_name("Organization")
      end
      should_redirect_to("The organizations url"){ organizations_url }
    end
    
    
  end
  
end
