class UserReaction < ApplicationRecord
  log_book
  strip_attributes

  self.primary_key = :uuid
  include HasUuid

  enum :kind, positive: "positive", negative: "negative"

  belongs_to :message
  has_one :user_favorite, dependent: :destroy
  has_one :front_user, through: :message

  validates :message_id, presence: true, uniqueness: true

  scope :order_by_recent, -> { order("created_at desc") }
end
