require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @password = "foobar"
    @user = users(:michael)
    sign_in(user: @user, password: @password)
  end

  test "should show the post" do
    get post_path(posts(:orange))
    assert_response :success
  end
end
