require 'test_helper'

class NotificationTest < ActiveSupport::TestCase

  def setup
    @user = users(:archer)
    @post = posts(:orange)
    @post_author = @post.user
  end

  test "notification is dependent on like" do
    @like = @user.likes.create!(likeable: @post)
    assert_difference 'Notification.count', 1 do
      @notification = @like.create_notification!(actor_id: @user.id,
                                                 recipient_id: @post_author.id)
    end
    assert @notification.actor == @user
    assert @notification.recipient == @post_author
    assert @user.sent_notifications.first == @notification
    assert @post_author.received_notifications.first == @notification
    assert_difference 'Notification.count', -1 do
      Like.find(@like.id).destroy
    end
  end

  test "notification is dependent on comment" do
    @comment = @post.comments.create(user_id: @user.id,
                                    content: "Lorem Ipsum")
    assert_difference 'Notification.count', 1 do
      @notification = @comment.create_notification!(actor_id: @user.id,
                                                    recipient_id: @post_author.id)
    end
    assert @notification.actor == @user
    assert @notification.recipient == @post_author
    assert @user.sent_notifications.first == @notification
    assert @post_author.received_notifications.first == @notification
    assert_difference 'Notification.count', -1 do
      Comment.find(@comment.id).destroy
    end
  end
end
