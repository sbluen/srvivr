require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get create" do
    get :create, name: "jdoe", password: "secret"
    assert_redirected_to :root
  end

  test "should get destroy" do
    get :destroy, user_id: 1
    assert_redirected_to :root
  end

end
