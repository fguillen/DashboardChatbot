class Conversation < ApplicationRecord
  log_book
  strip_attributes

  self.primary_key = :uuid
  include HasUuid

  belongs_to :front_user
  belongs_to :alert_email, optional: true
  has_many :messages, dependent: :destroy

  validates :title, presence: true

  scope :order_by_recent, -> { order("conversations.created_at desc") }
  scope :no_from_alert, -> { where(alert_email_id: nil) }

  def add_message(message)
    puts ">>>> add_message: #{message.to_hash}"
    self.messages << message
  end

  def find_tool_call_by_id(tool_call_id)
    messages.map(&:tool_calls).flatten.compact.find do |tool_call|
      tool_call[:id] == tool_call_id
    end
  end

  def first_message_at
    messages.minimum(:created_at)
  end

  def last_message_at
    messages.maximum(:created_at)
  end

  def subconversations
    Conversation::MessagesListToSubconversationsService.perform(self)
  end

  def to_hash_raw
    {
      uuid:,
      title:,
      first_message_at: first_message_at&.to_formatted_s(:datetime_with_time_zone),
      last_message_at: last_message_at&.to_formatted_s(:datetime_with_time_zone),
      messages: messages.in_order.map(&:raw),
    }
  end

  def to_hash
    {
      uuid:,
      title:,
      first_message_at: first_message_at&.to_formatted_s(:datetime_with_time_zone),
      last_message_at: last_message_at&.to_formatted_s(:datetime_with_time_zone),
      messages: messages.in_order.map(&:to_hash),
    }
  end

  def to_json
    JSON.pretty_generate(to_hash)
  end

  def to_hash_for_api
    {
      uuid:,
      title:,
      first_message_at: first_message_at&.to_formatted_s(:datetime_with_time_zone),
      last_message_at: last_message_at&.to_formatted_s(:datetime_with_time_zone),
      messages_count: messages.count,
      models: messages.map(&:model).compact.uniq,
      tokens:
    }
  end

  def tokens
    messages.map(&:tokens).compact.sum
  end

  def messages_until(message)
    messages.where("messages.order <= ?", message.order).in_order
  end
end
