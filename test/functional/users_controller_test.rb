require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    @input_attributes = {
      name: "sam",
      password: "private",
      password_confirmation: "private",
      lng: 34.4149,
      lat: -119.8431
    }

  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: @input_attributes
    end

    #TODO: Change to where we want the user to go after logging in.
    assert_redirected_to '/edit_my_profile'
  end

  test "should show user" do
    get :show, id: @user.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user.to_param
    assert_response :success
  end

  test "should update user" do
    put :update, id: @user.to_param, user: @input_attributes
    #TODO: Change to where we want the user to go after logging in.
    assert_redirected_to '/'
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user.to_param
    end

    #TODO: Change to where we want the user to go after logging in.
    assert_redirected_to '/'
    
  end
end
