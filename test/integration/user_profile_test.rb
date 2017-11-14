require 'test_helper'

class UserShowTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    sign_in(user: @user, password: "foobar")
  end

  test "profile display" do
    get user_path(@user)
    assert_equal request.original_fullpath, user_path(@user)
    assert_select 'title', @user.name
    assert_select 'h1', text: @user.name
    # assert_select 'h1>img.gravatar'

    assert_select 'a[href=?]', following_user_path
    assert_select 'a[href=?]', followers_user_path
    assert_select 'strong#followers', text: "#{@user.followers.count}"
    assert_select 'strong#following', text: "#{@user.following.count}"

    # assert_match @user.microposts.count.to_s, response.body
    # assert_select 'div.pagination'
    # @user.microposts.paginate(page: 1).each do |micropost|
    #  assert_match micropost.content, response.body
    # end
  end
end
