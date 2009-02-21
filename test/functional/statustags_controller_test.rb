require 'test_helper'

class StatustagsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:statustags)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create statustag" do
    assert_difference('Statustag.count') do
      post :create, :statustag => { }
    end

    assert_redirected_to statustag_path(assigns(:statustag))
  end

  test "should show statustag" do
    get :show, :id => statustags(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => statustags(:one).id
    assert_response :success
  end

  test "should update statustag" do
    put :update, :id => statustags(:one).id, :statustag => { }
    assert_redirected_to statustag_path(assigns(:statustag))
  end

  test "should destroy statustag" do
    assert_difference('Statustag.count', -1) do
      delete :destroy, :id => statustags(:one).id
    end

    assert_redirected_to statustags_path
  end
end
