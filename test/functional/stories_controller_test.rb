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
    should_route :post, "/projects/1/stories/2/start", :action => :start, :id => 2, :project_id => 1
    should_route :post, "/projects/1/stories/2/stop", :action => :stop, :id => 2, :project_id => 1
    should_route :post, "/projects/1/stories/2/finish", :action => :finish, :id => 2, :project_id => 1
    should_route :post, "/projects/1/stories/2/update_priority", :action => :update_priority, :id => 2, :project_id => 1
    should_route :post, "/projects/1/stories/2/update_size", :action => :update_size, :id => 2, :project_id => 1
    
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
      @story = @project.stories.first
    end
    
    context "and do GET to :index in a project I belong to" do
      setup do
        get :index, :project_id => @project.to_param
      end
      should_respond_with :ok
      # should_assign_to(:project){ @project }
      # should_assign_to(:stories){ @project.stories }
      should "return the stories in json format" do
        assert_equal @project.stories.to_json, @response.body
      end
    end

    context "and do GET to :new in a project I belong to" do
      setup do
        get :new, :project_id => @project.to_param
      end
      should_respond_with :ok
      # should_assign_to(:project){ @project }
      # should_assign_to(:story)
      # should_render_template :new
    end
    
    context "and do POST to :create in a project I belong to with correct data" do
      setup do
        post :create, :project_id => @project.to_param, :story => { :name => "My Story 1" }
        @story = Story.find_by_name("My Story 1")
      end
      should_respond_with :created
      # should_assign_to(:project){ @project }
      # should_assign_to(:story)
      should "return the story in json format" do
        assert_equal @story.to_json, @response.body
      end
    end

    context "and do POST to :create with new realid" do
      setup do
        post :create, :project_id => @project.to_param, :story => { :name => "New Realid", :realid => "ASD001" }
        @story = Story.find_by_name("New Realid")
      end
      should "return the story in json format" do
        assert_equal "ASD001", @story.realid
      end
    end

    context "and do POST to :create in a project I belong to with wrong data" do
      setup do
        post :create, :project_id => @project.to_param, :story => { }
        @story = Story.find_by_name("My Story 1")
      end
      should_respond_with :precondition_failed
      # should_assign_to(:project){ @project }
      # should_assign_to(:story)
      should "return the errors in json format" do
        assert_equal [['name', "can't be blank"]].to_json, @response.body
      end
    end

    context "and do GET to :edit in a project I belong to" do
      setup do
        get :edit, :id => @story.to_param, :project_id => @project.to_param
      end
      should_respond_with :ok
      # should_assign_to(:project){ @project }
      # should_assign_to(:story){ @story}
      # should_render_template :edit
    end
    
    context "and do PUT to :update in a project I belong to with correct data" do
      setup do
        put :update, :id => @story.to_param, :project_id => @project.to_param, :story => { :name => "My Story 1" }
        @story.reload
      end
      should_respond_with :ok
      # should_assign_to(:project){ @project }
      # should_assign_to(:story){ @story }
      should "return the story in json format" do
        assert_equal @story.to_json, @response.body
      end
      should "update the story" do
        assert_equal "My Story 1", @story.name
      end
    end

    context "and do PUT to :update to change the realid" do
      setup do
        put :update, :id => @story.to_param, :project_id => @project.to_param, :story => { :realid => "BBB001" }
        @story.reload
      end
      should "update the realid" do
        assert_equal "BBB001", @story.realid
      end
    end

    context "and do PUT to :update in a project I belong to with wrong data" do
      setup do
        put :update, :id => @story.to_param, :project_id => @project.to_param, :story => { :name => nil }
        @story.reload
      end
      should_respond_with :precondition_failed
      # should_assign_to(:story){ @story }
      # should_assign_to(:project){ @project }
      should "return the errors in json format" do
        assert_equal [['name', "can't be blank"]].to_json, @response.body
      end
    end
    
    context "on DELETE to :destroy" do
      setup do
        delete :destroy, :project_id => @project.to_param, :id => @story.to_param
      end
      should_respond_with :ok
      # should_not_set_the_flash
      # should_assign_to(:project){ @project }
      # should_assign_to(:story){ @story }
      
      should "destroy the story" do
        assert_raise ActiveRecord::RecordNotFound do
            @story.reload
        end
      end
    end
    
    # Start, Stop and Finish stories
    context "and do POST to :start in a project I belong to" do
      setup do
        @story.stop
        post :start, :id => @story.to_param, :project_id => @project.to_param
      end
      should_respond_with :ok
      # should_assign_to(:project){ @project }
      # should_assign_to(:story){ @story }
      should "Start the story" do
        @story.reload
        assert @story.started?
      end
    end
    
    context "and do POST to :stop in a project I belong to" do
      setup do
        @story.start
        post :stop, :id => @story.to_param, :project_id => @project.to_param
      end
      should_respond_with :ok
      # should_assign_to(:project){ @project }
      # should_assign_to(:story){ @story }
      should "Stop the story" do
        @story.reload
        assert @story.stopped?
      end
    end
    
    context "and do POST to :finish in a project I belong to" do
      setup do
        @story.start
        post :finish, :id => @story.to_param, :project_id => @project.to_param
      end
      should_respond_with :ok
      # should_assign_to(:project){ @project }
      # should_assign_to(:story){ @story }
      should "Finish the story" do
        @story.reload
        assert @story.finished?
      end
    end

    context "and do POST to :update_priority in a project I belong to" do
      setup do
        post :update_priority, :value => 3000, :id => @story.to_param, :project_id => @project.to_param
      end
      should_respond_with :ok
      # should_assign_to(:project){ @project }
      # should_assign_to(:story){ @story }
      should "update the priority" do
        @story.reload
        assert_equal 3000, @story.priority
      end
    end

    context "and do POST to :update_size in a project I belong to" do
      setup do
        post :update_size, :value => 5, :id => @story.to_param, :project_id => @project.to_param
      end
      should_respond_with :ok
      # should_assign_to(:project){ @project }
      # should_assign_to(:story){ @story }
      should "update the size" do
        @story.reload
        assert_equal 5, @story.size
      end
    end
    
    context "and do GET to :tasks_by_status in a project I belong to with not_started" do
      setup do
        @task = @story.tasks.create()
        @task.stop
        @task.reload
        post :tasks_by_status, :status => "not_started", :id => @story.to_param, :project_id => @project.to_param
      end
      should_respond_with :ok

    end

    context "and do GET to :tasks_by_status in a project I belong to with in_progress" do
      setup do
        @task = @story.tasks.create()
        @task.start
        @task.reload
        post :tasks_by_status, :status => "in_progress", :id => @story.to_param, :project_id => @project.to_param
      end
      should_respond_with :ok
    end

    context "and do GET to :tasks_by_status in a project I belong to with finished" do
      setup do
        @task = @story.tasks.create()
        @task.finish
        @task.reload
        post :tasks_by_status, :status => "finished", :id => @story.to_param, :project_id => @project.to_param
      end
      should_respond_with :ok
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
      # should_assign_to(:project){ @project }
      # should_assign_to(:stories){ @project.stories }
      should "return the stories in json format" do
        assert_equal @project.stories.to_json, @response.body
      end
    end
    
    context "and do GET to :new in a project from my organization" do
      setup do
        get :new, :project_id => @project.to_param
      end
      should_respond_with :ok
      # should_assign_to(:project){ @project }
      # should_assign_to(:story)
      # should_render_template :new
    end
    
    context "and do POST to :create in a project from my organization with correct data" do
      setup do
        post :create, :project_id => @project.to_param, :story => { :name => "My Story 1" }
        @story = Story.find_by_name("My Story 1")
      end
      should_respond_with :created
      # should_assign_to(:project){ @project }
      # should_assign_to(:story)
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
      # should_assign_to(:project){ @project }
      # should_assign_to(:story)
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
      # should_assign_to(:project){ @project }
      # should_assign_to(:story){ @story}
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
      # should_assign_to(:project){ @project }
      # should_assign_to(:stories){ @project.stories }
      should "return the stories in json format" do
        assert_equal @project.stories.to_json, @response.body
      end
    end
    
    context "and do GET to :new in a project" do
      setup do
        get :new, :project_id => @project.to_param
      end
      should_respond_with :ok
      # should_assign_to(:project){ @project }
      # should_assign_to(:story)
      # should_render_template :new
    end
    
    context "and do POST to :create in a project with correct data" do
      setup do
        post :create, :project_id => @project.to_param, :story => { :name => "My Story 1" }
        @story = Story.find_by_name("My Story 1")
      end
      should_respond_with :created
      # should_assign_to(:project){ @project }
      # should_assign_to(:story)
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
      # should_assign_to(:project){ @project }
      # should_assign_to(:story)
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
      # should_assign_to(:project){ @project }
      # should_assign_to(:story){ @story}
      # should_render_template :edit
    end
    
  end
end
