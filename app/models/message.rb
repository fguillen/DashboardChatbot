class Message < ApplicationRecord
  log_book
  strip_attributes

  self.primary_key = :uuid
  include HasUuid

  enum :role, { system: "system", user: "user", assistant: "assistant", tool: "tool" }

  belongs_to :conversation
  has_one :front_user, through: :conversation

  validates :role, presence: true
  validates :body, presence: true
  validates :body, length: { in: 1..65_535 }

  scope :order_by_recent, -> { order("messages.created_at desc") }
end
