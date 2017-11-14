require 'test_helper'

class LikeTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @post = posts(:orange)
    @comment = @post.comments.create!(user_id: @user.id,
                                      content: "That's a nice buck")
  end

  test "should like the post only once and be able to unlike the post" do
    assert_difference 'Like.count', 1 do
      @user.like(@post)
    end
    assert_no_difference 'Like.count' do
      @user.like(@post)
    end
    assert @user.liked_posts.include?(@post)
    assert @post.likers.include?(@user)
    assert_difference 'Like.count', -1 do
      @user.unlike(@post)
    end
    assert_not @user.liked_posts.include?(@post)
  end

  test "post like needs a likeable" do
    like = @post.likes.build
    assert_not like.valid?
    like = @user.likes.build
    assert_not like.valid?
    like = @user.likes.build(likeable: @post)
    assert like.valid?
    assert like.save
    assert @user.likes.include?(like)
    assert @post.likers.include?(@user)
    assert_equal like.user, @user
    assert_equal like.likeable, @post
  end



  test "should like the comment only once and unlike the comment" do
    assert_difference 'Like.count', 1 do
      @user.like(@comment)
    end
    assert_no_difference 'Like.count' do
      @user.like(@comment)
    end
    assert @user.liked_comments.include?(@comment)
    assert @comment.likers.include?(@user)
    assert_difference 'Like.count', -1 do
      @user.unlike(@comment)
    end
    assert_not @user.liked_comments.include?(@comment)
  end
end
