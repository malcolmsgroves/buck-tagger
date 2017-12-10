class Notification < ApplicationRecord
  belongs_to :actor, class_name: 'User'
  belongs_to :recipient, class_name: 'User'
  belongs_to :notifiable, polymorphic: true

  validates :actor_id, presence: true
  validates :recipient_id, presence: true
  validates :notifiable_id, presence: true
  validates :notifiable_type, presence: true,
             uniqueness: { scope: [:notifiable_id] }
  before_create :unview

  def view
    update_attribute(:viewed, true)
    reload
    puts viewed
  end

  private
    def unview
      self.viewed = false
    end
end
