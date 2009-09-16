require 'test_helper'

class NametagsControllerTest < ActionController::TestCase
 test "validate that the task id belongs to a story that belongs to the project passed" do
   login_as_administrator
   post :create, { :project_id => projects(:find_the_island).id, :nametag => { :task_id => tasks(:non_widmore_task).id, :member_id => 1, :relative_position_x => 1, :relative_position_y => 1 }}
   assert_response :bad_request

   login_as_administrator
   put :update, { :project_id => projects(:find_the_island).id, :id => 1, :nametag_id => nametags(:one).id, :nametag => { :task_id => tasks(:non_widmore_task).id, :member_id => 1, :relative_position_x => 1024, :relative_position_y => 1 } }
   assert_response :bad_request

 end
 
 ########################## Permissions tests ##########################
 test "nametags should be able to be created only if you admin the project or you belong to it" do
  login_as_administrator
  assert_difference('Nametag.count') do
    post :create, { :project_id => projects(:find_the_island).id, :nametag => { :task_id => tasks(:in_progress_1).id, :member_id => 1, :relative_position_x => 1, :relative_position_y => 1 }}
  end
  assert_response :ok

  login_as_organization_admin
  assert_difference('Nametag.count') do
    post :create, { :project_id => projects(:find_the_island).id, :nametag => { :task_id => tasks(:in_progress_1).id, :member_id => 1, :relative_position_x => 1, :relative_position_y => 1 }}
  end
  assert_response :ok

  login_as_normal_user
  assert_difference('Nametag.count') do
    post :create, { :project_id => projects(:find_the_island).id, :nametag => { :task_id => tasks(:in_progress_1).id, :member_id => 1, :relative_position_x => 1, :relative_position_y => 1 }}
  end
  assert_response :ok

  login_as(members(:jburke))
  assert_no_difference('Nametag.count') do
    post :create, { :project_id => projects(:find_the_island).id, :nametag => { :task_id => tasks(:in_progress_1).id, :member_id => 1, :relative_position_x => 1, :relative_position_y => 1 }}
  end
  assert_response 302
 end

 test "nametags should be able to be updated only if you admin the project or you belong to it" do
    login_as_administrator
    put :update, { :project_id => projects(:find_the_island).id, :id => 1, :nametag_id => nametags(:one).id, :nametag => { :task_id => tasks(:in_progress_1).id, :member_id => 1, :relative_position_x => 1024, :relative_position_y => 1 } }
    assert_response :ok
    nametags(:one).reload
    assert_equal tasks(:in_progress_1), nametags(:one).task
    assert_equal 1024, nametags(:one).relative_position_x

    login_as_organization_admin
    put :update, {:project_id => projects(:find_the_island).id, :id => 1, :project_id => projects(:find_the_island).id, :nametag_id => nametags(:one).id, :nametag => { :task_id => tasks(:in_progress_1).id, :member_id => 1, :relative_position_x => 1025, :relative_position_y => 1 } }
    assert_response :ok
    nametags(:one).reload
    assert_equal tasks(:in_progress_1), nametags(:one).task
    assert_equal 1025, nametags(:one).relative_position_x

    login_as_normal_user
    put :update, {:project_id => projects(:find_the_island).id, :id => 1, :nametag_id => nametags(:one).id, :nametag => { :task_id => tasks(:in_progress_1).id, :member_id => 1, :relative_position_x => 1024, :relative_position_y => 1 } }
    assert_response :ok
    nametags(:one).reload
    assert_equal tasks(:in_progress_1), nametags(:one).task
    assert_equal 1024, nametags(:one).relative_position_x

    login_as(members(:jburke))
    put :update, {:project_id => projects(:find_the_island).id, :id => 1, :project_id => projects(:find_the_island).id, :nametag_id => nametags(:one).id, :nametag => { :task_id => tasks(:not_started_1).id, :member_id => 1, :relative_position_x => 1025, :relative_position_y => 1 } }
    assert_response 302
    nametags(:one).reload
    assert_equal tasks(:in_progress_1), nametags(:one).task
    assert_equal 1024, nametags(:one).relative_position_x
 end
 
 test "nametags should be able to be deleted only if you admin the project or you belong to it" do
   login_as_administrator
   assert_difference('Nametag.count', -1) do
     delete :destroy, {:project_id => projects(:find_the_island).id, :nametag_id => nametags(:one).id}
   end
   assert_response :ok

   login_as_organization_admin
   assert_difference('Nametag.count', -1) do
     delete :destroy, {:project_id => projects(:find_the_island).id, :nametag_id => nametags(:two).id}
   end
   assert_response :ok
   
   login_as(members(:jburke))
   assert_no_difference('Nametag.count', -1) do
     delete :destroy, {:project_id => projects(:find_the_island).id, :nametag_id => nametags(:three).id}
   end
   assert_response 302
   
   login_as_normal_user
   assert_difference('Nametag.count', -1) do
     delete :destroy, {:project_id => projects(:find_the_island).id, :nametag_id => nametags(:three).id}
   end
   assert_response :ok
 end
end
