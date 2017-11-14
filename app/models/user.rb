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

  has_many :liked_posts,     through: :likes,
                             source: :likeable,
                             source_type: 'Post'
  has_many :liked_comments,  through: :likes,
                             source: :likeable,
                             source_type: 'Comment'
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

  # Returns true if the current user likes the likeable
  def like?(likeable)
    likes.where(likeable: likeable).present?
  end

  # Likes a post or comment
  def like(likeable)
    likes.create(likeable: likeable)
  end

  # Unlikes a post or comment
  def unlike(likeable)
    like = likes.find_by(likeable: likeable)
    likes.delete(like)
  end



  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Post.where("user_id IN (#{following_ids}) " +
                "OR user_id = :user_id", user_id: id).order(created_at: :desc)
  end
end
