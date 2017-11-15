require 'test_helper'

class NotificationsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @password = "foobar"
    @user = users(:michael)
    sign_in(user: @user, password: @password)
  end

  test "should get index" do
    get notifications_path
    assert_response :success
  end

end
