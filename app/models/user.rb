class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, omniauth_providers: [:google_oauth2]

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

  has_many :sent_notifications, class_name: 'Notification',
                                foreign_key: :actor_id
  has_many :received_notifications, class_name: 'Notification',
                                    foreign_key: :recipient_id

  mount_uploader :picture, PictureUploader

  # Follows a user.
  def follow(other_user)
    active_relationships.create!(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    following.destroy(other_user)
  end

  # Gets the users last location
  def last_location
    location = ''
    begin
      location = JSON.parse(posts.where.not(location: [nil, ""]).first.location)
    rescue
      location = { lat: 44, lng: -70 }
    end
    location
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
    likes.destroy(like)
  end

  def notification_feed(page)
    received_notifications.paginate(page: page).order(created_at: :desc)
  end



  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Post.where("user_id IN (#{following_ids}) " +
                "OR user_id = :user_id", user_id: id).order(created_at: :desc)
  end



  def self.find_for_google_oauth2(access_token, signed_in_resource = nil)
    data = access_token.info
    user = User.where(:provider => access_token.provider, :uid => access_token.uid ).first
    if user
      return user
    else
      registered_user = User.where(:email => access_token.info.email).first
      if registered_user
        return registered_user
      else
        access_token.provider = "Google"
        user = User.create(name: data["name"],
          provider: access_token.provider,
          email: data["email"],
          birthdate: "1 January 2000",
          password: Devise.friendly_token[0,20])
      end
    end
  end

end
