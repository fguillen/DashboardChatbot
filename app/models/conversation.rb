class Conversation < ApplicationRecord
  log_book
  strip_attributes

  self.primary_key = :uuid
  include HasUuid

  belongs_to :front_user
  has_many :messages, dependent: :destroy

  validates :title, presence: true

  scope :order_by_recent, -> { order("conversations.created_at desc") }

  def add_message(role:, content: nil, raw: nil, tool_calls: nil, tool_call_id: nil, model: nil)
    order = (messages.maximum(:order) || 0) + 1
    messages.create!(role:, content:, raw:, tool_calls:, tool_call_id:, model:, order:)
  end

  def find_tool_call_by_id(tool_call_id)
    messages.map(&:tool_calls).flatten.compact.find do |tool_call|
      tool_call["id"] == tool_call_id
    end
  end
end
