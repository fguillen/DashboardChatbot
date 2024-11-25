class UserReaction < ApplicationRecord
  log_book
  strip_attributes

  self.primary_key = :uuid
  include HasUuid

  enum :kind, positive: "positive", negative: "negative"

  belongs_to :message

  scope :order_by_recent, -> { order("created_at desc") }
end
