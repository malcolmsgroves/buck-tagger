class Post < ApplicationRecord
  belongs_to :user
  validates :content, presence: true, length: { maximum: 250 }
  validates :user_id, presence: true
  has_many :comments
  has_many :likes
  has_many :commenters, through: :comments, source: :user
  has_many :likers,     through: :likes, source: :user

  default_scope -> { order(created_at: :desc) }
end
