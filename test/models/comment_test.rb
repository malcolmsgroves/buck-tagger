require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @post = posts(:orange)
    @content = "lorem ipsum"
  end

  test "content should be present" do
    comment = @post.comments.build(user_id: @user.id)
    assert_not comment.valid?
    comment.content = @content
    assert comment.valid?
  end

  test "Comment needs user_id and post_id" do
    comment = @post.comments.build(content: @content)
    assert_not comment.valid?
    comment = @user.comments.build(content: @content)
    assert_not comment.valid?
    comment = @user.comments.build(content: @content, post_id: @post.id)
    assert comment.valid?
  end

  test "should comment on the post" do
    comment = @post.comments.create!(user_id: @user.id, content: @content)
    assert @user.commented_posts.include?(@post)
    assert @post.commenters.include?(@user)
    @post.comments.delete(comment)
    assert_not @user.commented_posts.include?(@post)
    assert_not @post.commenters.include?(@user)
  end

end
