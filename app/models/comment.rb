class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  validates :content, presence: true, length: { maximum: 250 }
  validates :user_id, presence: true
  validates :post_id, presence: true
  has_many :likes, as: :likeable,
                   dependent: :destroy
  has_many :likers, through: :likes, source: :user
end
