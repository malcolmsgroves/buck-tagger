require 'test_helper'

class PostInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    sign_in(user: @user, password: "foobar")
  end

  test "post interface without deer" do
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'
    # Invalid submission
    post posts_path,
         params: { post: { content: "" } }
    assert_select 'div#error_explanation'
    # Valid submission
    content = "This micropost really ties the room together"
    picture = fixture_file_upload('test/fixtures/katahdin.jpg', 'image/jpg')
    assert_difference 'Post.count', 1 do
      post posts_path,
           params: { post: { content: content, picture: picture } }
    end
    assert assigns(:post).picture?
    follow_redirect!
    assert_match content, response.body
    # Delete a post.
    assert_select 'a', 'delete'
    first_post = @user.posts.paginate(page: 1).first
    assert_difference 'Post.count', -1 do
      delete post_path(first_post)
    end
    # Visit a different user.
    get user_path(users(:archer))
    assert_select 'a', { text: 'delete', count: 0 }
  end

  test "post interface with a deer" do
    get root_path
    county = counties(:addison)
    content = "This micropost really ties the room together"
    picture = fixture_file_upload('test/fixtures/katahdin.jpg', 'image/jpg')
    deer = {weight: 150, sex: 'buck', county_id: county.id, points: 10, season: 'archery'}
    assert_difference 'Post.count', 1 do
      post posts_path,
           params: { post: { content: content, picture: picture, deer_attributes: deer } }
    end
    assert assigns(:post).picture?
    assert assigns(:post).deer
    follow_redirect!
    assert_match content, response.body
    assert_match deer[:season], response.body
    # Delete a post.
    assert_select 'a', 'delete'
    first_post = @user.posts.paginate(page: 1).first
    assert_difference 'Post.count', -1 do
      assert_difference 'Deer.count', -1 do
        delete post_path(first_post)
      end
    end
  end
end
