require File.dirname(__FILE__) + '/../test_helper'

class ProjectsControllerTest < ActionController::TestCase
  context "Permissions" do
    should_require_organization_admin_on [ :new, :create , :edit, :update, :destroy ]
    should_require_belong_to_project_or_admin_on [:show]
  end
  context "Project Routes" do
    should_route :get, "/organizations/1/projects/new", :action => :new, :organization_id => 1
    should_route :post, "/organizations/1/projects", :action => :create, :organization_id => 1
    should_route :get, "/organizations/1/projects/2/edit", :action => :edit, :id => 2, :organization_id => 1
    should_route :put, "/organizations/1/projects/2", :action => :update, :id => 2, :organization_id => 1
    should_route :delete, "/organizations/1/projects/2", :action => :destroy, :id => 2, :organization_id => 1
    should_route :get, "/organizations/1/projects/2", :action => :show, :id => 2, :organization_id => 1
  end
  
  # ----------------------------------------------------------------------------------------------------------------
  # Organization Admin
  # ----------------------------------------------------------------------------------------------------------------
  context "If i'm an organization admin" do
    setup do
      @organization = Factory(:organization)
      @user = Factory(:user)
      @project = @organization.projects.create(:name => "Project Test")
      @user.add_to_organization(@organization)
    end
    
    should "admin the organization" do
      assert @user.admins?(@organization)
    end

    context "and do GET to :new" do
      setup do
        get :new, :organization_id => @organization.to_param
      end
      should_respond_with :ok
      # should_assign_to(:organization){ @organization }
      # should_assign_to(:project)
      # should_render_template :new
    end
    
    context "and do a POST to :create.json with correct data" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        post :create, :project => { :name => "Project" }, :organization_id => @organization.to_param
        @project = Project.find_by_name("Project")
      end
      should_respond_with :created
      # should_not_set_the_flash
      # should_assign_to(:organization){ @organization }
      # should_assign_to(:project)
      
      should "create the project" do
        assert !!@project
      end
      
      should "add the project to the organization" do
        assert @organization.projects.include?(@project)
      end
      
      should "return the project json" do
        assert_match @project.to_json, @response.body
      end
    end

    context "and do POST to :create.json with incorrect data" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        post :create, :organization_id => @organization.to_param, :project => {}
      end
      should_respond_with :precondition_failed
      # should_not_set_the_flash
      # should_assign_to(:organization){ @organization }

      should "return the errors json" do
        assert_match /can't be blank/, @response.body
      end
    end
    
    context "and do GET to :edit" do
      setup do
        get :edit, :id => @project.to_param, :organization_id => @organization.to_param
      end
      should_respond_with :ok
      # should_not_set_the_flash
      # should_assign_to(:organization){ @organization }
      # should_assign_to(:project){ @project }
      # should_render_template :edit
    end
    
    context "and do a PUT to :update.json with correct data" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        put :update, :id => @project.to_param, :organization_id => @organization.to_param, :project => { :name => "Project Test 2" }
        @project = Project.find_by_name("Project Test 2")
        
      end
      should_respond_with :ok
      # should_not_set_the_flash
      # should_assign_to(:organization){ @organization }
      # should_assign_to(:project){ @project }
      should "update the project" do
        assert !!@project
      end
      
      should "return the project json" do
        assert_match @project.to_json, @response.body
      end
    end
    
    context "and do a PUT to :update.json with incorrect data" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        put :update, :id => @project.to_param, :organization_id => @organization.to_param, :project => { :name => "" }
      end
      should_respond_with :precondition_failed
      # should_not_set_the_flash
      # should_assign_to(:organization){ @organization }
      # should_assign_to(:project){ @project }
      
      should "return the errors json" do
        assert_match /can't be blank/, @response.body
      end
    end
    
    context "and do DELETE to :destroy.json" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        delete :destroy, :id => @project.to_param, :organization_id => @organization.to_param
      end
      should_respond_with :ok
      # should_not_set_the_flash
      # should_assign_to(:organization){ @organization }
      # should_assign_to(:project){ @project }
      
      should "destroy the organization" do
        assert_raise ActiveRecord::RecordNotFound do
            @project.reload
        end
      end
    end
    
    context "and do GET to :show an organization I administer" do
      setup do
        get :show, :id => @project.to_param, :organization_id => @organization.to_param
      end
      should_respond_with :ok
      should_assign_to(:organization){ @organization }
      should_assign_to(:project){ @project }
      should_render_template :show
    end

    context "and do GET to :show an organization I administer with ajax" do
      setup do
        xhr :get, :show, :id => @project.to_param, :organization_id => @organization.to_param
      end
      should_respond_with :ok
      should_assign_to(:organization){ @organization }
      should_assign_to(:project){ @project }
      should_render_template :show_ajax
    end

    context "and do GET to :show an organization I don't administer" do
      setup do
        @organization = Factory(:organization)
        @project = @organization.projects.first
        get :show, :id => @project.to_param, :organization_id => @organization.to_param
      end
      should_set_the_flash_to("Access Denied")
      should_redirect_to("the root page"){ root_url }
    end
    
  end
  
  # ----------------------------------------------------------------------------------------------------------------
  # System Admin
  # ----------------------------------------------------------------------------------------------------------------
  context "If I'm an admin" do
    setup do
      @organization = Factory(:organization)
      @project = @organization.projects.create(:name => "Project Test")
      @user = admin_user
    end

    context "and do GET to :new" do
      setup do
        get :new, :organization_id => @organization.to_param
      end
      should_respond_with :ok
      # should_assign_to(:organization){ @organization }
      # should_assign_to(:project)
      # should_render_template :new
    end
    
    context "and do a POST to :create.json with correct data" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        post :create, :project => { :name => "Project" }, :organization_id => @organization.to_param
        @project = Project.find_by_name("Project")
      end
      should_respond_with :created
      # should_not_set_the_flash
      # should_assign_to(:organization){ @organization }
      # should_assign_to(:project)
      
      should "create the project" do
        assert @project
      end
      
      should "add the project to the organization" do
        assert @organization.projects.include?(@project)
      end
      
      should "return the project json" do
        assert_match @project.to_json, @response.body
      end
    end

    context "and do POST to :create.json with incorrect data" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        post :create, :organization_id => @organization.to_param, :project => {}
      end
      should_respond_with :precondition_failed
      # should_assign_to(:organization){ @organization }
      # should_not_set_the_flash
      # 
      should "return the errors json" do
        assert_match /can't be blank/, @response.body
      end
    end
    
    context "and do GET to :edit" do
      setup do
        get :edit, :id => @project.to_param, :organization_id => @organization.to_param
      end
      should_respond_with :ok
      # should_not_set_the_flash
      # should_assign_to(:organization){ @organization }
      # should_assign_to(:project){ @project }
      # should_render_template :edit
    end
    
    context "and do a PUT to :update.json with correct data" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        put :update, :id => @project.to_param, :organization_id => @organization.to_param, :project => { :name => "Project Test 2" }
        @project = Project.find_by_name("Project Test 2")
        
      end
      should_respond_with :ok
      # should_not_set_the_flash
      # should_assign_to(:organization){ @organization }
      # should_assign_to(:project){ @project }
      
      should "update the project" do
        assert !!@project
      end
      
      should "return the project json" do
        assert_match @project.to_json, @response.body
      end
    end
    
    context "and do a PUT to :update.json with incorrect data" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        put :update, :id => @project.to_param, :organization_id => @organization.to_param, :project => { :name => "" }
      end
      should_respond_with :precondition_failed
      # should_not_set_the_flash
      # should_assign_to(:organization){ @organization }
      # should_assign_to(:project){ @project }
      
      should "return the errors json" do
        assert_match /can't be blank/, @response.body
      end
    end
    
    context "and do DELETE to :destroy.json" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        delete :destroy, :id => @project.to_param, :organization_id => @organization.to_param
      end
      should_respond_with :ok
      # should_not_set_the_flash
      # should_assign_to(:project){ @project }
      
      should "destroy the organization" do
        assert_raise ActiveRecord::RecordNotFound do
            @project.reload
        end
      end
    end
    
    context "and do GET to :show an organization I belong to" do
      setup do
        get :show, :id => @project.to_param, :organization_id => @organization.to_param
      end
      should_respond_with :ok
      # should_assign_to(:organization){ @organization }
      # should_assign_to(:project){ @project }
      # should_render_template :show
    end

    context "and do GET to :show an organization I don't belong to" do
      setup do
        @organization = Factory(:organization)
        @project = @organization.projects.first
        get :show, :id => @project.to_param, :organization_id => @organization.to_param
      end
      should_respond_with :ok
      # should_assign_to(:organization){ @organization }
      # should_assign_to(:project){ @project }
      # should_render_template :show
    end
  end
  
  context "If I'm a normal user" do
    setup do
      @organization = Factory(:organization)
      @admin = not_logged_user
      @admin.add_to_organization(@organization)
      @organization.reload
      @user = Factory(:user)
      @user.add_to_organization(@organization)
      @organization.reload
      @project = @organization.projects.first
    end

    context "and do GET to :show in a project I belong to" do
      setup do
        
        get :show, :id => @project.to_param, :organization_id => @organization.to_param
      end
      should_respond_with :ok
      should_assign_to(:organization){ @organization }
      should_assign_to(:project){ @project }
      should_render_template :show
    end
  end
  
end
