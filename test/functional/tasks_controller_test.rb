require File.dirname(__FILE__) + '/../test_helper'

class TasksControllerTest < ActionController::TestCase
  context "If i'm a normal user" do
    setup do
      @user = Factory(:user)
    end

  end

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

  end
  
  context "If I'm an admin" do
    setup do
      @user = admin_user
    end
    
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
end
