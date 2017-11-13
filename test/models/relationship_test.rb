require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "should follow and unfollow other user" do
    @user.follow(@other_user)
    assert @user.following.include?(@other_user)
    assert @other_user.followers.include?(@user)
    @user.unfollow(@other_user)
    assert_not @user.following.include?(@other_user)
    assert_not @other_user.followers.include?(@user)
  end

  test "must have follower_id and followed_id" do
    relationship = Relationship.new(followed_id: @user.id)
    assert_not relationship.valid?
    relationship = Relationship.new(follower_id: @user.id)
    assert_not relationship.valid?
    relationship = Relationship.new(follower_id: @user.id,
                                    followed_id: @other_user.id)
    assert relationship.valid?
  end
end
