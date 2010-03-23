require File.dirname(__FILE__) + '/../test_helper'

class StoriesControllerTest < ActionController::TestCase
  context "Permissions" do
    should_require_belong_to_project_or_admin_on [:index, :new, :create, :edit, :update, :destroy ]
  end
  
  context "Stories Routes" do
    should_route :get, "/projects/1/stories", :action => :index, :project_id => 1
    should_route :get, "/projects/1/stories/new", :action => :new, :project_id => 1
    should_route :post, "/projects/1/stories", :action => :create, :project_id => 1
    should_route :get, "/projects/1/stories/2/edit", :action => :edit, :id => 2, :project_id => 1
    should_route :put, "/projects/1/stories/2", :action => :update, :id => 2, :project_id => 1
    should_route :delete, "/projects/1/stories/2", :action => :destroy, :id => 2, :project_id => 1
    should_route :get, "/projects/1/stories/2", :action => :show, :id => 2, :project_id => 1
  end

  # ----------------------------------------------------------------------------------------------------------------
  # Normal User
  # ----------------------------------------------------------------------------------------------------------------
  context "If I'm a normal user" do
    setup do
      @organization = Factory(:organization)
      @team = @organization.teams.first
      @project = @organization.projects.first
      @user = Factory(:user)
      @admin = Factory(:user)
      @admin.add_to_organization(@organization)
      @organization.reload
      @user.add_to_organization(@organization)
      assert @team.users.include?(@user)
    end
    
    context "and do GET to :index in a project I belong to" do
      setup do
        get :index, :project_id => @project.to_param
      end
      should_respond_with :ok
      should_assign_to(:project){ @project }
      should_assign_to(:stories){ @project.stories }
      should "return the stories in json format" do
        assert_equal @project.stories.to_json, @response.body
      end
    end

    context "and do GET to :new in a project I belong to" do
      setup do
        get :new, :project_id => @project.to_param
      end
      should_respond_with :ok
      should_assign_to(:project){ @project }
      should_assign_to(:story)
      should_render_template :new
    end
    
    context "and do POST to :create in a project I belong to with correct data" do
      setup do
        post :create, :project_id => @project.to_param, :story => { :name => "My Story 1" }
        @story = Story.find_by_name("My Story 1")
      end
      should_respond_with :created
      should_assign_to(:project){ @project }
      should_assign_to(:story)
      should "return the story in json format" do
        assert_equal @story.to_json, @response.body
      end
    end

    context "and do POST to :create in a project I belong to with wrong data" do
      setup do
        post :create, :project_id => @project.to_param, :story => { }
        @story = Story.find_by_name("My Story 1")
      end
      should_respond_with :precondition_failed
      should_assign_to(:project){ @project }
      should_assign_to(:story)
      should "return the errors in json format" do
        assert_equal [['name', "can't be blank"]].to_json, @response.body
      end
    end

    context "and do GET to :edit in a project I belong to" do
      setup do
        @story = @project.stories.first
        get :edit, :id => @story.to_param, :project_id => @project.to_param
      end
      should_respond_with :ok
      should_assign_to(:project){ @project }
      should_assign_to(:story){ @story}
      should_render_template :edit
    end
    
    context "and do PUT to :update in a project I belong to with correct data" do
      setup do
        put :update, :id => @project.stories.first, :project_id => @project.to_param, :story => { :name => "My Story 1" }
        @story = @project.stories.first
        @story.reload
      end
      should_respond_with :ok
      should_assign_to(:project){ @project }
      should_assign_to(:story){ @story }
      should "return the story in json format" do
        assert_equal @story.to_json, @response.body
      end
      should "update the story" do
        assert_equal "My Story 1", @story.name
      end
    end

    context "and do PUT to :update in a project I belong to with wrong data" do
      setup do
        put :update, :id => @project.stories.first, :project_id => @project.to_param, :story => { :name => nil }
        @story = @project.stories.first
        @story.reload
      end
      should_assign_to(:story){ @story }
      should_respond_with :precondition_failed
      should_assign_to(:project){ @project }
      should "return the errors in json format" do
        assert_equal [['name', "can't be blank"]].to_json, @response.body
      end
    end
    
    context "on DELETE to :destroy" do
      setup do
        @story = @project.stories.first
        delete :destroy, :project_id => @project.to_param, :id => @story.to_param
      end
      should_respond_with :ok
      should_not_set_the_flash
      should_assign_to(:project){ @project }
      should_assign_to(:story){ @story }
      
      should "destroy the story" do
        assert_raise ActiveRecord::RecordNotFound do
            @story.reload
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
      @team = @organization.teams.first
      @project = @organization.projects.first
      @user = Factory(:user)
      @user.add_to_organization(@organization)
      @organization.reload
      @team.users.delete(@user)
      assert !@team.users.include?(@user)
    end
  
    should "admin the organization" do
      assert @user.admins?(@organization)
    end
    
    context "and do GET to :index in a project from my organization" do
      setup do
        get :index, :project_id => @project.to_param
      end
      should_respond_with :ok
      should_assign_to(:project){ @project }
      should_assign_to(:stories){ @project.stories }
      should "return the stories in json format" do
        assert_equal @project.stories.to_json, @response.body
      end
    end
    
    context "and do GET to :new in a project from my organization" do
      setup do
        get :new, :project_id => @project.to_param
      end
      should_respond_with :ok
      should_assign_to(:project){ @project }
      should_assign_to(:story)
      should_render_template :new
    end
    
    context "and do POST to :create in a project from my organization with correct data" do
      setup do
        post :create, :project_id => @project.to_param, :story => { :name => "My Story 1" }
        @story = Story.find_by_name("My Story 1")
      end
      should_respond_with :created
      should_assign_to(:project){ @project }
      should_assign_to(:story)
      should "return the story in json format" do
        assert_equal @story.to_json, @response.body
      end
    end
    
    context "and do POST to :create in a project I belong to with wrong data" do
      setup do
        post :create, :project_id => @project.to_param, :story => { }
        @story = Story.find_by_name("My Story 1")
      end
      should_respond_with :precondition_failed
      should_assign_to(:project){ @project }
      should_assign_to(:story)
      should "return the errors in json format" do
        assert_equal [['name', "can't be blank"]].to_json, @response.body
      end
    end
    
    
    context "and do GET to :edit in a project I belong to" do
      setup do
        @story = @project.stories.first
        get :edit, :id => @story.to_param, :project_id => @project.to_param
      end
      should_respond_with :ok
      should_assign_to(:project){ @project }
      should_assign_to(:story){ @story}
      should_render_template :edit
    end
    
  end
  
  # ----------------------------------------------------------------------------------------------------------------
  # System Admin
  # ----------------------------------------------------------------------------------------------------------------
  context "If I'm an admin" do
    setup do
      @organization = Factory(:organization)
      @project = @organization.projects.first
      @user = admin_user
    end

    context "and do GET to :index in a project" do
      setup do
        get :index, :project_id => @project.to_param
      end
      should_respond_with :ok
      should_assign_to(:project){ @project }
      should_assign_to(:stories){ @project.stories }
      should "return the stories in json format" do
        assert_equal @project.stories.to_json, @response.body
      end
    end
    
    context "and do GET to :new in a project" do
      setup do
        get :new, :project_id => @project.to_param
      end
      should_respond_with :ok
      should_assign_to(:project){ @project }
      should_assign_to(:story)
      should_render_template :new
    end
    
    context "and do POST to :create in a project with correct data" do
      setup do
        post :create, :project_id => @project.to_param, :story => { :name => "My Story 1" }
        @story = Story.find_by_name("My Story 1")
      end
      should_respond_with :created
      should_assign_to(:project){ @project }
      should_assign_to(:story)
      should "return the story in json format" do
        assert_equal @story.to_json, @response.body
      end
    end
    
    context "and do POST to :create in a project I belong to with wrong data" do
      setup do
        post :create, :project_id => @project.to_param, :story => { }
        @story = Story.find_by_name("My Story 1")
      end
      should_respond_with :precondition_failed
      should_assign_to(:project){ @project }
      should_assign_to(:story)
      should "return the errors in json format" do
        assert_equal [['name', "can't be blank"]].to_json, @response.body
      end
    end
    
    context "and do GET to :edit in a project I belong to" do
      setup do
        @story = @project.stories.first
        get :edit, :id => @story.to_param, :project_id => @project.to_param
      end
      should_respond_with :ok
      should_assign_to(:project){ @project }
      should_assign_to(:story){ @story}
      should_render_template :edit
    end
    
  end
end
