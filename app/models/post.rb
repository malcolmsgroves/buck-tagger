class Post < ApplicationRecord
  belongs_to :user
  validates :content, length: { maximum: 250 }
  validates :user_id, presence: true
  validate :content_or_picture

  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable,
                   dependent: :destroy
  has_many :commenters, through: :comments, source: :user
  has_many :likers,     through: :likes, source: :user
  has_one :deer, dependent: :destroy
  accepts_nested_attributes_for :deer

  default_scope -> { order(created_at: :desc) }

  mount_uploader :picture, PictureUploader

  # Comments on a post
  def comment(text)
    comments.create!(user_id: current_user.id,
                     content: text)
  end

  # Delete a comment
  def uncomment(comment_to_delete)
    comments.delete(comment_to_delete)
  end

  private
    def content_or_picture
      if content.blank? && picture.blank?
        errors.add(:content, "Post must contain content or picture")
      end
    end
end
