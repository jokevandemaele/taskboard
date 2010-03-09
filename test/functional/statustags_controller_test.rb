require 'test_helper'

class StatustagsControllerTest < ActionController::TestCase
  # test "validate that the task id belongs to a story that belongs to the project passed" do
  #   login_as_administrator
  #   post :create, { :project_id => projects(:find_the_island).id, :statustag => { :task_id => tasks(:non_widmore_task).id, :status => "waiting", :relative_position_x => 1, :relative_position_y => 1 }}
  #   assert_response :bad_request
  # 
  #   login_as_administrator
  #   put :update, { :project_id => projects(:find_the_island).id, :id => 1, :id => statustags(:one).id, :statustag => { :task_id => tasks(:non_widmore_task).id, :status => "waiting", :relative_position_x => 1024, :relative_position_y => 1 } }
  #   assert_response :bad_request
  # 
  # end
  # 
  # ########################## Permissions tests ##########################
  # test "statustags should be able to be created only if you admin the project or you belong to it" do
  #  login_as_administrator
  #  assert_difference('Statustag.count') do
  #    post :create, { :project_id => projects(:find_the_island).id, :statustag => { :task_id => tasks(:in_progress_1).id, :status => "waiting", :relative_position_x => 1, :relative_position_y => 1 }}
  #  end
  #  assert_response :ok
  # 
  #  login_as_organization_admin
  #  assert_difference('Statustag.count') do
  #    response = post :create, { :project_id => projects(:find_the_island).id, :statustag => { :task_id => tasks(:in_progress_1).id, :status => "waiting", :relative_position_x => 1, :relative_position_y => 1 }}
  #  end
  #  assert_response :ok
  # 
  #  login_as_normal_user
  #  assert_difference('Statustag.count') do
  #    post :create, { :project_id => projects(:find_the_island).id, :statustag => { :task_id => tasks(:in_progress_1).id, :status => "waiting", :relative_position_x => 1, :relative_position_y => 1 }}
  #  end
  #  assert_response :ok
  # 
  #  login_as(members(:jburke))
  #  assert_no_difference('Statustag.count') do
  #    post :create, { :project_id => projects(:find_the_island).id, :statustag => { :task_id => tasks(:in_progress_1).id, :status => "waiting", :relative_position_x => 1, :relative_position_y => 1 }}
  #  end
  #  assert_response 302
  # end
  # 
  # test "statustags should be able to be updated only if you admin the project or you belong to it" do
  #    login_as_administrator
  #    put :update, { :project_id => projects(:find_the_island).id, :id => 1, :id => statustags(:one).id, :statustag => { :task_id => tasks(:in_progress_1).id, :status => "waiting", :relative_position_x => 1024, :relative_position_y => 1 } }
  #    assert_response :ok
  #    statustags(:one).reload
  #    assert_equal tasks(:in_progress_1), statustags(:one).task
  #    assert_equal 1024, statustags(:one).relative_position_x
  # 
  #    login_as_organization_admin
  #    put :update, {:project_id => projects(:find_the_island).id, :id => 1, :project_id => projects(:find_the_island).id, :id => statustags(:one).id, :statustag => { :task_id => tasks(:in_progress_1).id, :status => "waiting", :relative_position_x => 1025, :relative_position_y => 1 } }
  #    assert_response :ok
  #    statustags(:one).reload
  #    assert_equal tasks(:in_progress_1), statustags(:one).task
  #    assert_equal 1025, statustags(:one).relative_position_x
  # 
  #    login_as_normal_user
  #    put :update, {:project_id => projects(:find_the_island).id, :id => 1, :id => statustags(:one).id, :statustag => { :task_id => tasks(:in_progress_1).id, :status => "waiting", :relative_position_x => 1024, :relative_position_y => 1 } }
  #    assert_response :ok
  #    statustags(:one).reload
  #    assert_equal tasks(:in_progress_1), statustags(:one).task
  #    assert_equal 1024, statustags(:one).relative_position_x
  # 
  #    login_as(members(:jburke))
  #    put :update, {:project_id => projects(:find_the_island).id, :id => 1, :project_id => projects(:find_the_island).id, :id => statustags(:one).id, :statustag => { :task_id => tasks(:not_started_1).id, :status => "waiting", :relative_position_x => 1025, :relative_position_y => 1 } }
  #    assert_response 302
  #    statustags(:one).reload
  #    assert_equal tasks(:in_progress_1), statustags(:one).task
  #    assert_equal 1024, statustags(:one).relative_position_x
  # end
  # 
  # test "statustags should be able to be deleted only if you admin the project or you belong to it" do
  #   login_as_administrator
  #   assert_difference('Statustag.count', -1) do
  #     delete :destroy, {:project_id => projects(:find_the_island).id, :id => statustags(:one).id}
  #   end
  #   assert_response :ok
  # 
  #   login_as_organization_admin
  #   assert_difference('Statustag.count', -1) do
  #     delete :destroy, {:project_id => projects(:find_the_island).id, :id => statustags(:two).id}
  #   end
  #   assert_response :ok
  # 
  #   login_as(members(:jburke))
  #   assert_no_difference('Statustag.count', -1) do
  #     delete :destroy, {:project_id => projects(:find_the_island).id, :id => statustags(:three).id}
  #   end
  #   assert_response 302
  # 
  #   login_as_normal_user
  #   assert_difference('Statustag.count', -1) do
  #     delete :destroy, {:project_id => projects(:find_the_island).id, :id => statustags(:three).id}
  #   end
  #   assert_response :ok
  # end
  # 
  # 
  # # test "should update statustag" do
  # #   login_as_normal_user
  # #   put :update, { :id => 1, :id => statustags(:one).id,  }
  # #   statustags(:one).reload
  # #   assert_equal tasks(:in_progress_1), statustags(:one).task
  # #   assert_equal 1024, statustags(:one).relative_position_x
  # # end
  # # 
  # # test "should destroy statustag" do
  # #   login_as_normal_user
  # #   assert_difference('Statustag.count', -1) do
  # #     delete :destroy, :id => statustags(:one).id
  # #   end
  # # end
  # # test "validate that the task id belongs to a story that belongs to the project passed" do
  # # end
  # # 
  # # ########################## Permissions tests ##########################
  # # test "statustags should be able to be created only if you admin the project or you belong to it" do
  # # end
  # # test "statustags should be able to be updated only if you admin the project or you belong to it" do
  # # end
  # # test "statustags should be able to be deleted only if you admin the project or you belong to it" do
  # # end
end
