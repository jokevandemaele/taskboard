require File.dirname(__FILE__) + '/../test_helper'

class StatustagsControllerTest < ActionController::TestCase
  context "Permissions" do
    should_require_belong_to_project_or_admin_on [ :create, :update, :destroy ]
  end

  context "Statustags Routes" do
    should_route :post, "/projects/1/stories/2/tasks/3/statustags", :action => :create, :project_id => 1, :story_id => 2, :task_id => 3
    should_route :put, "/projects/1/stories/2/tasks/3/statustags/4", :action => :update, :id => 4, :project_id => 1, :story_id => 2, :task_id => 3
    should_route :delete, "/projects/1/stories/2/tasks/3/statustags/4", :action => :destroy, :id => 4, :project_id => 1, :story_id => 2, :task_id => 3
  end
  

  context "If i'm a normal user" do
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
    
    context "and do POST to :create in a project i belong to with correct data" do
      setup do
        post :create, :project_id => @project.to_param, :story_id => @story.to_param, :task_id => @task.to_param, :statustag => { :status => "DONE", :relative_position_x => 10, :relative_position_y => 10  }
      end
      should_respond_with :created
      should "create the statustag" do
        @task.reload
        assert_equal "DONE", @task.statustags.first.status
      end
    end

    context "and do POST to :create in a project i belong to with incorrect data" do
      setup do
        post :create, :project_id => @project.to_param, :story_id => @story.to_param, :task_id => @task.to_param, :statustag => { }
      end
      should_respond_with :precondition_failed
    end

    context "and do PUT to :update in a project i belong to with correct data" do
      setup do
        @tag = @task.statustags.create(:status => "DONE")
        put :update, :project_id => @project.to_param, :story_id => @story.to_param, :task_id => @task.to_param, :id => @tag.id, :statustag => { :status => "please_test", :relative_position_x => 1, :relative_position_y => 100, :task_id => @task.to_param }
      end
      should_respond_with :ok
      should "update the statustag" do
        @tag.reload
        assert_equal "please_test", @tag.status
        assert_equal 1, @tag.relative_position_x
        assert_equal 100, @tag.relative_position_y
      end
    end
    
    context "and do PUT to :update in a project i belong to with incorrect data" do
      setup do
        @tag = @task.statustags.create(:status => "DONE")
        put :update, :project_id => @project.to_param, :story_id => @story.to_param, :task_id => @task.to_param, :id => @tag.id, :statustag => { :status => nil, :task_id => @task.to_param }
      end
      should_respond_with :precondition_failed
    end

    context "on DELETE to :destroy" do
      setup do
        @tag = @task.statustags.create(:status => "DONE")
        delete :destroy, :project_id => @project.to_param, :story_id => @story.to_param, :task_id => @task.to_param, :id => @tag.to_param
      end
      should_respond_with :ok
      should "destroy the tag" do
        assert_raise ActiveRecord::RecordNotFound do
            @tag.reload
        end
      end
    end
  end

  # context "If i'm an organization admin" do
  #   setup do
  #     @organization = Factory(:organization)
  #     @user = Factory(:user)
  #     @mem = @organization.organization_memberships.build(:user => @user)
  #     @mem.admin = true
  #     @mem.save
  #   end
  #   
  #   should "admin the organization" do
  #     assert @user.organizations_administered.include?(@organization)
  #   end
  # 
  # end
  # 
  # context "If I'm an admin" do
  #   setup do
  #     @user = admin_user
  #   end
  #   
  # end
end
