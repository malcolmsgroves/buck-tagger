module UsersHelper
  def current_user?(user)
    user == current_user
  end

  def following?(user)
    user.following.include?(user)
  end
end
