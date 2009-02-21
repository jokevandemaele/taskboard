require 'test_helper'

class NametagsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:nametags)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create nametag" do
    assert_difference('Nametag.count') do
      post :create, :nametag => { }
    end

    assert_redirected_to nametag_path(assigns(:nametag))
  end

  test "should show nametag" do
    get :show, :id => nametags(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => nametags(:one).id
    assert_response :success
  end

  test "should update nametag" do
    put :update, :id => nametags(:one).id, :nametag => { }
    assert_redirected_to nametag_path(assigns(:nametag))
  end

  test "should destroy nametag" do
    assert_difference('Nametag.count', -1) do
      delete :destroy, :id => nametags(:one).id
    end

    assert_redirected_to nametags_path
  end
end
