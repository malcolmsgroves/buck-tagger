require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
  end

  test "must have birthdate" do
    assert @user.valid?
    @user.birthdate = nil
    assert_not @user.valid?
  end

  test "must have name" do
    @user.name = nil
    assert_not @user.valid?
  end

  test "must have email" do
    @user.email = nil
    assert_not @user.valid?
  end

end
