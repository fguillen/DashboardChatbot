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

  def self.extract_function_arguments(tool_call)
    puts ">>>> tool_call: #{tool_call}"
    case tool_call["function"]["name"]
    when "database__execute"
      JSON.parse(tool_call["function"]["arguments"])["input"]
    when "database__describe_tables"
      JSON.parse(tool_call["function"]["arguments"])["tables"]
    else
      raise "unknown tool call name: '#{tool_call["function"]["name"]}'"
    end
  end

  def self.extract_function_arguments_language(tool_call)
    case tool_call["function"]["name"]
    when "database__execute"
      "sql"
    when "database__describe_tables"
      "txt"
    else
      raise "unknown tool call name: '#{tool_call["function"]["name"]}'"
    end
  end
end
