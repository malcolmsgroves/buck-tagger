class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, presence: true
  validates :birthdate, presence: true
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :following, through: :active_relationships, source: :followed

  has_many :posts,    dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes,    dependent: :destroy

  has_many :liked_posts,     through: :likes, source: :post
  has_many :commented_posts, through: :comments, source: :post

  # Follows a user.
  def follow(other_user)
    following << other_user
  end

  # Unfollows a user.
  def unfollow(other_user)
    following.delete(other_user)
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  # Likes a post
  def like(post)
    likes.create!(post_id: post.id)
  end

  # Unlikes a post
  def unlike(post)
    like = likes.find_by(post_id: post.id)
    likes.delete(like)
  end

  # Comments on a post
  def comment(parameters)
    comments.create!(post_id: parameters[:post].id,
                     content: parameters[:content])
  end

  # Delete a comment
  def uncomment(comment_to_delete)
    comments.delete(comment_to_delete)
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Post.where("user_id IN (#{following_ids}) " +
                "OR user_id = :user_id", user_id: id).order(created_at: :desc)
  end
end
