class Deer < ApplicationRecord
  belongs_to :county
  belongs_to :post

  validates :county_id, presence: true
end
