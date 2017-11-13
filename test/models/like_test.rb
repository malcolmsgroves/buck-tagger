require 'test_helper'

class LikeTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @post = posts(:orange)
  end

  test "should like the post" do
    @user.like(@post)
    assert @user.liked_posts.include?(@post)
    assert @post.likers.include?(@user)
    @user.unlike(@post)
    assert !@user.liked_posts.include?(@post)
    assert !@post.likers.include?(@user)
  end

  test "like needs a user_id and post_id" do
    like = @post.likes.build
    assert_not like.valid?
    like = @user.likes.build
    assert_not like.valid?
    like = @user.likes.build(post_id: @post.id)
    assert like.valid?
  end
end
