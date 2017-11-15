module NotificationsHelper

  def describe(notification)
    actor = current_user?(notification.actor) ? "You" : notification.actor.name
    if notification.notifiable_type == 'Comment'
      "#{actor} commented on your post"
    elsif notification.notifiable_type == 'Like'
      if notification.notifiable.likeable_type == 'Post'
        "#{actor} liked your post"
      elsif notification.notifiable.likeable_type == 'Comment'
        "#{actor} liked your comment"
      end
    elsif notification.notifiable_type == 'Relationship'
      "#{actor} started following you"
    end
  end

  def notifiable_path(notification)
    if notification.notifiable_type == 'Comment'
      post_path notification.notifiable.post
    elsif notification.notifiable_type == 'Like'
      if notification.notifiable.likeable_type == 'Post'
        post_path notification.notifiable.likeable
      elsif notification.notifiable.likeable_type == 'Comment'
        post_path notification.notifiable.likeable.post
      end
    elsif notification.notifiable_type == 'Relationship'
      user_path notification.actor
    end
  end
end
