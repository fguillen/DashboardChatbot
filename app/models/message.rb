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
  scope :by_role, -> (role) { where(role: role) }

  # If content can be parsed to JSON
  # store it as JSON
  def content=(data)
    puts ">>> message.data: #{data}"
    puts ">>> message.data.class.name: #{data.class.name}"

    begin
      super(JSON.pretty_generate(JSON.parse(data)))
    rescue JSON::ParserError
      super(data)
    end
  end

  def self.extract_function_arguments(tool_call)
    puts ">>>> tool_call: #{tool_call}"
    case tool_call["function"]["name"]
    when "database__execute"
      JSON.parse(tool_call["function"]["arguments"])["input"]
    when "database__describe_tables"
      JSON.parse(tool_call["function"]["arguments"])["tables"]
    when "database__list_tables"
      nil
    when "chart__create_line_chart"
      JSON.parse(tool_call["function"]["arguments"])["data"]
    when "chart__create_column_chart"
      JSON.parse(tool_call["function"]["arguments"])["data"]
    else
      puts ">>> (extract_function_arguments) unknown tool call name: '#{tool_call["function"]["name"]}'"

    end
  end

  def self.extract_function_arguments_language(tool_call)
    case tool_call["function"]["name"]
    when "database__execute"
      "sql"
    when "database__describe_tables"
      "txt"
    when "chart__create_line_chart"
      "chart_line"
    when "chart__create_column_chart"
      "chart_column"
    else
      puts ">>> (extract_function_arguments_language) unknown tool call name: '#{tool_call["function"]["name"]}'"
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
    when "chart__create_line_chart"
      "chart_line"
    when "chart__create_column_chart"
      "chart_column"
    else
      puts ">>> (content_language) unknown tool call name: '#{tool_call["function"]["name"]}'"
      "txt"
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
      # content_fixed = content.gsub(/:(\w+)=>/, '"\1":')
      # content_fixed = content_fixed.gsub(":nil", ":null")
      # content_fixed = content_fixed.gsub(/:(\w{3},\s[\w\s]+\d{4})/) { |e| ":\"#{Date.parse(e)}\"" } # dates like: "Thu, 09 May 2024"
      # content_fixed = content_fixed.gsub(/:(\d\d\d\d-\d\d-\d\d\s\d\d:\d\d:\d\d\s.\d\d\d\d),/) { |e| ":\"#{Date.parse(e)}\"," } # dates like: "2024-06-01 00:00:00 +0200"
      # JSON.pretty_generate(JSON.parse(content_fixed))

      JSON.pretty_generate(SafeRuby.eval(content))
    when "database__describe_tables"
      content
    when "database__list_tables"
      # content_fixed = content.gsub(/:(\w+)/, '"\1"')
      # JSON.pretty_generate(JSON.parse(content_fixed))
      JSON.pretty_generate(SafeRuby.eval(content))
    when "chart__create_line_chart"
      content
    when "chart__create_column_chart"
      content
    else
      message = "ToolCall not Found: #{tool_call["function"]["name"]}"
      puts ">>> #{message}"
      Rails.logger.error(message)

      content
    end

  rescue => e
    message = "Exception while parsing message [#{id}] content: #{e.message}, content: #{content}"
    puts ">>> #{message}"
    Rails.logger.error(message)
    Rails.logger.error(e.backtrace.join("\n"))

    content
  end
end
