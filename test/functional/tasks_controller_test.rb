require File.dirname(__FILE__) + '/../test_helper'

class TasksControllerTest < ActionController::TestCase
  context "Permissions" do
    should_require_belong_to_project_or_admin_on [:index, :new, :create, :edit, :update, :destroy ]
  end
  
  context "Tasks Routes" do
    should_route :get, "/projects/1/stories/2/tasks", :action => :index, :project_id => 1, :story_id => 2
    should_route :get, "/projects/1/stories/2/tasks/new", :action => :new, :project_id => 1, :story_id => 2
    should_route :post, "/projects/1/stories/2/tasks", :action => :create, :project_id => 1, :story_id => 2
    should_route :get, "/projects/1/stories/2/tasks/3/edit", :action => :edit, :id => 3, :project_id => 1, :story_id => 2
    should_route :post, "/projects/1/stories/2/tasks/3/update_name", :action => :update_name, :id => 3, :project_id => 1, :story_id => 2
    should_route :post, "/projects/1/stories/2/tasks/3/update_description", :action => :update_description, :id => 3, :project_id => 1, :story_id => 2
    should_route :post, "/projects/1/stories/2/tasks/3/update_color", :action => :update_color, :id => 3, :project_id => 1, :story_id => 2
    should_route :delete, "/projects/1/stories/2/tasks/3", :action => :destroy, :id => 3, :project_id => 1, :story_id => 2
    should_route :get, "/projects/1/stories/2/tasks/3", :action => :show, :id => 3, :project_id => 1, :story_id => 2
    should_route :post, "/projects/1/stories/2/tasks/3/start", :action => :start, :id => 3, :project_id => 1, :story_id => 2
    should_route :post, "/projects/1/stories/2/tasks/3/stop", :action => :stop, :id => 3, :project_id => 1, :story_id => 2
    should_route :post, "/projects/1/stories/2/tasks/3/finish", :action => :finish, :id => 3, :project_id => 1, :story_id => 2
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
      @task = @story.tasks.first
    end
    
    context "and do GET to :index in a project I belong to" do
      setup do
        get :index, :project_id => @project.to_param, :story_id => @story.to_param
      end
      should_respond_with :ok
      # should_assign_to(:project){ @project }
      # should_assign_to(:story){ @story}
      # should_assign_to(:tasks){ @story.tasks }
      should "return the tasks in json format" do
        assert_equal @story.tasks.to_json, @response.body
      end
    end
  
    context "and do GET to :new in a project I belong to" do
      setup do
        get :new, :project_id => @project.to_param, :story_id => @story.to_param
      end
      should_respond_with :ok
      # should_assign_to(:project){ @project }
      # should_assign_to(:story){ @story }
      # should_assign_to(:task)
      should_render_template :new
    end
    
    context "and do POST to :create in a project I belong to with correct data" do
      setup do
        post :create, :project_id => @project.to_param, :story_id => @story.to_param, :task => { :name => "My Task 1" }
        @task = Task.find_by_name("My Task 1")
        @expected = { :project => @project.id, :story => @story.id }
      end
      should_respond_with :created
      # should_assign_to(:project){ @project }
      # should_assign_to(:story){ @story }
      # should_assign_to(:task)
      should "return the project and story in json format" do
        assert_equal @expected.to_json, @response.body
      end
    end

    context "and do POST to :update_name in a project I belong to with correct data" do
      setup do
        post :update_name, :id => @story.tasks.first, :project_id => @project.to_param, :story_id => @story.to_param, :value => "My Task 1"
        @task.reload
      end
      should_respond_with :ok
      # should_assign_to(:project){ @project }
      # should_assign_to(:story){ @story }
      # should_assign_to(:task){ @task }
      should "return the name" do
        assert_equal "My Task 1", @response.body
      end
      should "update the task" do
        assert_equal "My Task 1", @task.name
      end
    end

    context "and do POST to :update_description in a project I belong to with correct data" do
      setup do
        post :update_description, :id => @story.tasks.first, :project_id => @project.to_param, :story_id => @story.to_param, :value => "My Task Description"
        @task.reload
      end
      should_respond_with :ok
      # should_assign_to(:project){ @project }
      # should_assign_to(:story){ @story }
      # should_assign_to(:task){ @task }
      should "return the description" do
        assert_equal "My Task Description", @response.body
      end
      should "update the task" do
        assert_equal "My Task Description", @task.description
      end
    end

    context "and do POST to :update_color in a project I belong to with correct data" do
      setup do
        post :update_color, :id => @story.tasks.first, :project_id => @project.to_param, :story_id => @story.to_param, :value => "red"
        @task.reload
      end
      should_respond_with :ok
      # should_assign_to(:project){ @project }
      # should_assign_to(:story){ @story }
      # should_assign_to(:task){ @task }
      should "update the task" do
        assert_equal "red", @task.color
      end
    end
  
    context "on DELETE to :destroy" do
      setup do
        delete :destroy, :project_id => @project.to_param, :story_id => @story.to_param, :id => @task.to_param
      end
      should_respond_with :ok
      # should_not_set_the_flash
      # should_assign_to(:project){ @project }
      # should_assign_to(:story){ @story }
      # should_assign_to(:task){ @task }
      
      should "destroy the task" do
        assert_raise ActiveRecord::RecordNotFound do
            @task.reload
        end
      end
    end
    # Start, Stop and Finish tasks
    context "and do POST to :start in a project I belong to" do
      setup do
        @task.stop
        post :start, :id => @task.to_param, :project_id => @project.to_param, :story_id => @story.to_param
      end
      should_respond_with :ok
      # should_assign_to(:project){ @project }
      # should_assign_to(:story){ @story }
      # should_assign_to(:task){ @task }
      should "Start the task" do
        @task.reload
        assert @task.started?
      end
    end

    context "and do POST to :start in a project I belong to and change the story id" do
      setup do
        @task.stop
        post :start, :id => @task.to_param, :project_id => @project.to_param, :story_id => @story.to_param, :new_story_id => @project.stories.second.id
      end
      should_respond_with :ok
      # should_assign_to(:project){ @project }
      # should_assign_to(:story){ @story }
      # should_assign_to(:task){ @task }
      should "Change its story" do
        @task.reload
        assert @task.started?
        assert_equal @project.stories.second, @task.story
      end
    end
    
    context "and do POST to :stop in a project I belong to" do
      setup do
        @task.start
        post :stop, :id => @task.to_param, :project_id => @project.to_param, :story_id => @story.to_param
      end
      should_respond_with :ok
      # should_assign_to(:project){ @project }
      # should_assign_to(:story){ @story }
      # should_assign_to(:task){ @task }
      should "Stop the task" do
        @task.reload
        assert @task.stopped?
      end
    end
    
    context "and do POST to :stop in a project I belong to and change the story id" do
      setup do
        @task.start
        post :stop, :id => @task.to_param, :project_id => @project.to_param, :story_id => @story.to_param, :new_story_id => @project.stories.second.id
      end
      should "Change its story" do
        @task.reload
        assert_equal @project.stories.second, @task.story
      end
    end
    
    context "and do POST to :finish in a project I belong to" do
      setup do
        @task.start
        post :finish, :id => @task.to_param, :project_id => @project.to_param, :story_id => @story.to_param
      end
      should_respond_with :ok
      # should_assign_to(:project){ @project }
      # should_assign_to(:story){ @story }
      # should_assign_to(:task){ @task }
      should "Finish the task" do
        @task.reload
        assert @task.finished?
      end
    end
    
    context "and do POST to :finish in a project I belong to and change the story id" do
      setup do
        @task.start
        post :finish, :id => @task.to_param, :project_id => @project.to_param, :story_id => @story.to_param, :new_story_id => @project.stories.second.id
      end
      should "Change its story" do
        @task.reload
        assert_equal @project.stories.second, @task.story
      end
    end
  end
  # # ----------------------------------------------------------------------------------------------------------------
  # # Organization Admin
  # # ----------------------------------------------------------------------------------------------------------------
  # context "If I'm an organization admin" do
  #   setup do
  #     @organization = Factory(:organization)
  #     @team = @organization.teams.first
  #     @project = @organization.projects.first
  #     @user = Factory(:user)
  #     @user.add_to_organization(@organization)
  #     @organization.reload
  #     @team.users.delete(@user)
  #     assert !@team.users.include?(@user)
  #   end
  # 
  #   should "admin the organization" do
  #     assert @user.admins?(@organization)
  #   end
  #   
  #   context "and do GET to :index in a project from my organization" do
  #     setup do
  #       get :index, :project_id => @project.to_param
  #     end
  #     should_respond_with :ok
  #     should_assign_to(:project){ @project }
  #     should_assign_to(:tasks){ @project.tasks }
  #     should "return the tasks in json format" do
  #       assert_equal @project.tasks.to_json, @response.body
  #     end
  #   end
  #   
  #   context "and do GET to :new in a project from my organization" do
  #     setup do
  #       get :new, :project_id => @project.to_param
  #     end
  #     should_respond_with :ok
  #     should_assign_to(:project){ @project }
  #     should_assign_to(:task)
  #     should_render_template :new
  #   end
  #   
  #   context "and do POST to :create in a project from my organization with correct data" do
  #     setup do
  #       post :create, :project_id => @project.to_param, :task => { :name => "My Task 1" }
  #       @task = Task.find_by_name("My Task 1")
  #     end
  #     should_respond_with :created
  #     should_assign_to(:project){ @project }
  #     should_assign_to(:task)
  #     should "return the task in json format" do
  #       assert_equal @task.to_json, @response.body
  #     end
  #   end
  #   
  #   context "and do POST to :create in a project I belong to with wrong data" do
  #     setup do
  #       post :create, :project_id => @project.to_param, :task => { }
  #       @task = Task.find_by_name("My Task 1")
  #     end
  #     should_respond_with :precondition_failed
  #     should_assign_to(:project){ @project }
  #     should_assign_to(:task)
  #     should "return the errors in json format" do
  #       assert_equal [['name', "can't be blank"]].to_json, @response.body
  #     end
  #   end
  #   
  #   
  #   context "and do GET to :edit in a project I belong to" do
  #     setup do
  #       @task = @project.tasks.first
  #       get :edit, :id => @task.to_param, :project_id => @project.to_param
  #     end
  #     should_respond_with :ok
  #     should_assign_to(:project){ @project }
  #     should_assign_to(:task){ @task}
  #     should_render_template :edit
  #   end
  #   
  # end
  # 
  # # ----------------------------------------------------------------------------------------------------------------
  # # System Admin
  # # ----------------------------------------------------------------------------------------------------------------
  # context "If I'm an admin" do
  #   setup do
  #     @organization = Factory(:organization)
  #     @project = @organization.projects.first
  #     @user = admin_user
  #   end
  # 
  #   context "and do GET to :index in a project" do
  #     setup do
  #       get :index, :project_id => @project.to_param
  #     end
  #     should_respond_with :ok
  #     should_assign_to(:project){ @project }
  #     should_assign_to(:tasks){ @project.tasks }
  #     should "return the tasks in json format" do
  #       assert_equal @project.tasks.to_json, @response.body
  #     end
  #   end
  #   
  #   context "and do GET to :new in a project" do
  #     setup do
  #       get :new, :project_id => @project.to_param
  #     end
  #     should_respond_with :ok
  #     should_assign_to(:project){ @project }
  #     should_assign_to(:task)
  #     should_render_template :new
  #   end
  #   
  #   context "and do POST to :create in a project with correct data" do
  #     setup do
  #       post :create, :project_id => @project.to_param, :task => { :name => "My Task 1" }
  #       @task = Task.find_by_name("My Task 1")
  #     end
  #     should_respond_with :created
  #     should_assign_to(:project){ @project }
  #     should_assign_to(:task)
  #     should "return the task in json format" do
  #       assert_equal @task.to_json, @response.body
  #     end
  #   end
  #   
  #   context "and do POST to :create in a project I belong to with wrong data" do
  #     setup do
  #       post :create, :project_id => @project.to_param, :task => { }
  #       @task = Task.find_by_name("My Task 1")
  #     end
  #     should_respond_with :precondition_failed
  #     should_assign_to(:project){ @project }
  #     should_assign_to(:task)
  #     should "return the errors in json format" do
  #       assert_equal [['name', "can't be blank"]].to_json, @response.body
  #     end
  #   end
  #   
  #   context "and do GET to :edit in a project I belong to" do
  #     setup do
  #       @task = @project.tasks.first
  #       get :edit, :id => @task.to_param, :project_id => @project.to_param
  #     end
  #     should_respond_with :ok
  #     should_assign_to(:project){ @project }
  #     should_assign_to(:task){ @task}
  #     should_render_template :edit
  #   end
  #   
  # end
end

#  test "should get index" do
#    get :index
#    assert_response :success
#    assert_not_nil assigns(:tasks)
#  end

#  test "should get new" do
#    get :new
#    assert_response :success
#  end

#  test "should create task" do
#    assert_difference('Task.count') do
#      post :create, :task => { }
#    end

#    assert_redirected_to task_path(assigns(:task))
#  end

#  test "should show task" do
#    get :show, :id => tasks(:one).id
#    assert_response :success
#  end

#  test "should get edit" do
#    get :edit, :id => tasks(:one).id
#    assert_response :success
#  end

#  test "should update task" do
#    put :update, :id => tasks(:one).id, :task => { }
#    assert_redirected_to task_path(assigns(:task))
#  end

#  test "should destroy task" do
#    assert_difference('Task.count', -1) do
#      delete :destroy, :id => tasks(:one).id
#    end

#    assert_redirected_to tasks_path
#  end