class Post < ApplicationRecord
  belongs_to :user
  validates :content, presence: true, length: { maximum: 250 }
  validates :user_id, presence: true
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable,
                   dependent: :destroy
  has_many :commenters, through: :comments, source: :user
  has_many :likers,     through: :likes, source: :user

  default_scope -> { order(created_at: :desc) }

  # Comments on a post
  def comment(text)
    comments.create!(user_id: current_user.id,
                     content: text)
  end

  # Delete a comment
  def uncomment(comment_to_delete)
    comments.delete(comment_to_delete)
  end
end
