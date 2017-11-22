require 'test_helper'

class DeerTest < ActiveSupport::TestCase

  test "should create deer from post" do
    post = posts(:orange)
    deer = post.create_deer(weight: 150, sex: "buck", county_id: 1, points: 6, season: "archery")
    assert post.deer
    assert_equal post.deer, deer
    assert_equal post, deer.post
    assert_equal deer.weight, 150
  end
end
