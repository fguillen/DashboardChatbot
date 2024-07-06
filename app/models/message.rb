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
    when "database__list_tables"
      nil
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
    when "database__list_tables"
      "txt"
    else
      raise "unknown tool call name: '#{tool_call["function"]["name"]}'"
    end
  end

  def content_language
    return "txt" if content.blank?
    return "markdown" if !tool_call_id.present?

    tool_call = conversation.find_tool_call_by_id(tool_call_id)

    if tool_call.nil?
      message = "ToolCall not Found: #{tool_call_id}"
      Rails.logger.error(message)

      return "markdown"
    end

    case tool_call["function"]["name"]
    when "database__execute"
      "json"
    when "database__describe_tables"
      "sql"
    when "database__list_tables"
      "json"
    else
      raise "unknown tool call name: '#{tool_call["function"]["name"]}'"
    end

  end

  def content_parsed
    return content if content.blank? || tool_call_id.blank?

    tool_call = conversation.find_tool_call_by_id(tool_call_id)

    if tool_call.nil?
      message = "ToolCall not Found: #{tool_call_id}"
      Rails.logger.error(message)

      return "#{message}\n\n#{content}"
    end

    case tool_call["function"]["name"]
    when "database__execute"
      content_fixed = content.gsub(/:(\w+)=>/, '"\1":')
      content_fixed = content_fixed.gsub(":nil", ":null")
      JSON.pretty_generate(JSON.parse(content_fixed))
    when "database__describe_tables"
      content
    when "database__list_tables"
      content_fixed = content.gsub(/:(\w+)/, '"\1"')
      JSON.pretty_generate(JSON.parse(content_fixed))
    else
      raise "unknown tool call name: '#{tool_call["function"]["name"]}'"
    end
  end
end
