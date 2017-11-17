require 'test_helper'

class UserShowTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
    sign_in(user: @user, password: "foobar")
  end

  test "profile display" do
    get user_path(@user)
    assert_equal request.original_fullpath, user_path(@user)
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    # assert_select 'h1>img.gravatar'

    assert_select 'a[href=?]', following_user_path
    assert_select 'a[href=?]', followers_user_path
    assert_select 'strong#followers', text: "#{@user.followers.count}"
    assert_select 'strong#following', text: "#{@user.following.count}"

    # assert_match @user.microposts.count.to_s, response.body
    # assert_select 'div.pagination'
    @user.posts.paginate(page: 1).each do |post|
     assert_match post.content, response.body
    end
  end
end
