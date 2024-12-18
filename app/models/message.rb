class Message < ApplicationRecord
  log_book
  strip_attributes

  self.primary_key = :uuid
  include HasUuid

  enum :role, { system: "system", user: "user", assistant: "assistant", tool: "tool" }, prefix: true

  belongs_to :conversation
  has_one :front_user, through: :conversation
  has_one :user_reaction, dependent: :destroy

  validates :role, presence: true
  validates :order, uniqueness: { scope: :conversation_id }

  before_create :init_order
  before_save :set_model_from_raw, if: Proc.new { |message| message.model.nil? }

  serialize :raw, coder: JsonSerializerWithSymbolKeys
  serialize :completion_raw, coder: JsonSerializerWithSymbolKeys
  serialize :tool_calls, coder: JsonSerializerWithSymbolKeys

  after_create_commit do |message|
    puts ">>>>> broadcasting to: '#{conversation.id}_messages_stream'"
    broadcast_append_to(
      "#{conversation.id}_messages_stream",
      target: nil,
      targets: "#messages-list .subconversation:last-child",
      partial: "front/messages/message",
      locals: { message: }
    )
  end

  scope :order_by_recent, -> { order("messages.created_at desc") }
  scope :in_order, -> { order("messages.order asc") }
  scope :by_role, -> (role) { where(role: role) }

  def to_hash
    hash = {
      uuid:,
      tokens:,
      model:,
      created_at: created_at&.to_formatted_s(:datetime_with_time_zone),
      role:,
      content:,
      raw:,
      completion_raw:
    }

    hash[:tool_calls] = tool_calls if tool_calls.present?
    hash[:tool_call_id] = tool_call_id if tool_call_id.present?

    hash
  end

  def to_json
    JSON.pretty_generate(to_hash)
  end

  def tokens
    completion_raw&.dig(:usage, :total_tokens)
  end


  # If content can be parsed to JSON
  # store it as JSON
  def content=(data)
    if data.nil?
      super(data)
      return
    end

    begin
      super(JSON.pretty_generate(JSON.parse(data)))
    rescue JSON::ParserError
      super(data)
    end
  end

  def self.extract_function_arguments(tool_call)
    puts ">>>> tool_call: #{tool_call}"
    case tool_call[:function][:name]
    when "LangMini-Tools-Database__execute"
      JSON.parse(tool_call[:function][:arguments]).deep_symbolize_keys[:input]
    when "LangMini-Tools-Database__describe_tables"
      JSON.parse(tool_call[:function][:arguments]).deep_symbolize_keys[:tables]
    when "LangMini-Tools-Database__list_tables"
      nil
    when "Tools-Chart__create_line_chart"
      JSON.parse(tool_call[:function][:arguments]).deep_symbolize_keys[:data]
    when "Tools-Chart__create_column_chart"
      JSON.parse(tool_call[:function][:arguments]).deep_symbolize_keys[:data]
    when "Tools-Math__sum"
      JSON.parse(tool_call[:function][:arguments]).deep_symbolize_keys[:data]
    else
      puts ">>> (extract_function_arguments) unknown tool call name: '#{tool_call[:function][:name]}'"

    end
  end

  def self.extract_function_arguments_language(tool_call)
    case tool_call[:function][:name]
    when "LangMini-Tools-Database__execute"
      "sql"
    when "LangMini-Tools-Database__describe_tables"
      "txt"
    when "Tools-Chart__create_line_chart"
      "chart_line"
    when "Tools-Chart__create_column_chart"
      "chart_column"
    else
      puts ">>> (extract_function_arguments_language) unknown tool call name: '#{tool_call[:function][:name]}'"
    end
  end

  def content_language
    return "txt" if content.blank?
    return "markdown" if !tool_call_id.present?

    tool_call = conversation.find_tool_call_by_id(tool_call_id)

    if tool_call.nil?
      message = "Message.content_language ToolCall not Found: #{tool_call_id}"
      Rails.logger.error(message)

      return "markdown"
    end

    case tool_call[:function][:name]
    when "LangMini-Tools-Database__execute"
      "json"
    when "LangMini-Tools-Database__describe_tables"
      "sql"
    when "LangMini-Tools-Database__list_tables"
      "json"
    when "Tools-Chart__create_line_chart"
      "chart_line"
    when "Tools-Chart__create_column_chart"
      "chart_column"
    else
      puts ">>> (content_language) unknown tool call name: '#{tool_call[:function][:name]}'"
      "txt"
    end

  end

  def content_parsed
    return content if content.blank? || tool_call_id.blank?

    tool_call = conversation.find_tool_call_by_id(tool_call_id)

    if tool_call.nil?
      message = "Message.content_parsed ToolCall not Found: #{tool_call_id}"
      Rails.logger.error(message)

      return "#{message}\n\n#{content}"
    end

    case tool_call[:function][:name]
    when "LangMini-Tools-Database__execute"
      # content_fixed = content.gsub(/:(\w+)=>/, '"\1":')
      # content_fixed = content_fixed.gsub(":nil", ":null")
      # content_fixed = content_fixed.gsub(/:(\w{3},\s[\w\s]+\d{4})/) { |e| ":\"#{Date.parse(e)}\"" } # dates like: "Thu, 09 May 2024"
      # content_fixed = content_fixed.gsub(/:(\d\d\d\d-\d\d-\d\d\s\d\d:\d\d:\d\d\s.\d\d\d\d),/) { |e| ":\"#{Date.parse(e)}\"," } # dates like: "2024-06-01 00:00:00 +0200"
      # JSON.pretty_generate(JSON.parse(content_fixed))

      JSON.pretty_generate(SafeRuby.eval(content))
    when "LangMini-Tools-Database__describe_tables"
      content
    when "LangMini-Tools-Database__list_tables"
      # content_fixed = content.gsub(/:(\w+)/, '"\1"')
      # JSON.pretty_generate(JSON.parse(content_fixed))
      JSON.pretty_generate(SafeRuby.eval(content))
    when "Tools-Chart__create_line_chart"
      content
    when "Tools-Chart__create_column_chart"
      content
    when "Tools-Math__sum"
      content
    else
      message = "Message.content_parsed 2 ToolCall not Found: #{tool_call[:function][:name]}"
      puts ">>> #{message}"
      Rails.logger.error(message)

      content
    end

  rescue => e
    message = "Exception while parsing message [#{id}] error: #{e.message}, content: #{content}"
    puts ">>> #{message}"
    Rails.logger.error(message)
    Rails.logger.error(e.backtrace.join("\n"))

    content
  end

  def init_order
    self.order ||= conversation.messages.maximum(:order).to_i + 1
  end

  def set_model_from_raw
    return if raw.nil?

    self.model ||= raw[:model]
  end

  def user_reaction_positive?
    user_reaction&.positive?
  end

  def user_reaction_negative?
    user_reaction&.negative?
  end

  def user_reaction_negative_explanation
    return if user_reaction&.positive?
    user_reaction&.explanation
  end

  def is_model_final_answer?
    return false if assistant_name == "ModelAnswerSupervisorAssistant"
    role == "assistant" && content.present?
  end

  def is_debug?
    return false if ["chart_line", "chart_column"].include?(content_language)
    return true if assistant_name == "ModelAnswerSupervisorAssistant"
    role != "user" && !is_model_final_answer?
  end

  def content_without_examples
    return content if content.blank?
    content.gsub(/---Examples::INI---.*?---Examples::END---/m, "").strip
  end

  def content_examples
    return content if content.blank?
    result = content.match(/---Examples::INI---(.*.*?)---Examples::END---/m)
    return result if result.blank?
    result = result[1]
    return result if result.blank?
    result.gsub(/"""\n/, "").strip
  end

  def is_user?
    role == "user"
  end
end
