require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @password = "foobar"
  end

  test "should not sign user in with incorrect password" do
    get root_path
    assert_response :redirect
    follow_redirect!
    sign_in(user: @user, password: "password")
    assert request.original_fullpath.include?(new_user_session_path)
  end

  test "should sign user in with correct password" do
    get root_path
    assert_response :redirect
    follow_redirect!
    sign_in(user: @user, password: @password)
    assert_response :redirect
    follow_redirect!
    assert_equal request.original_fullpath, root_path
  end
end
