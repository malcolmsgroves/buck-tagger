require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @password = "foobar"
    @user = users(:michael)
    sign_in(user: @user, password: @password)
  end

  test "should get user profile" do
    get user_path @user
    assert_response :success
  end

  test "should get following path" do
    get following_user_path @user
    assert_response :success
  end

  test "should get followers path" do
    get followers_user_path @user
    assert_response :success
  end

  test "should get the index home page" do
    get users_path
    assert_response :success
  end

  test "should redirect to login when logged out" do
    delete destroy_user_session_path
    assert_response :redirect
    follow_redirect!
    get users_path
    assert_response :redirect
    sign_in(user: @user, password: @password)
    get root_path
    assert_response :success
  end
end
