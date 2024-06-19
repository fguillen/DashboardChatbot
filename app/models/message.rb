class Message < ApplicationRecord
  log_book
  strip_attributes

  self.primary_key = :uuid
  include HasUuid

  enum :role, { system: "system", user: "user", assistant: "assistant", tool: "tool" }

  serialize :tool_calls, type: Array, coder: YAML

  belongs_to :conversation
  has_one :front_user, through: :conversation

  validates :role, presence: true
  validates :order, uniqueness: { scope: :conversation_id }

  scope :order_by_recent, -> { order("messages.created_at desc") }
  scope :in_order, -> { order("messages.order asc") }
end
