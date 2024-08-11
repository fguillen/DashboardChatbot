class Assistants::DataAnalyst < AI::Assistant
  def initialize(
    model: "openrouter/auto",
    ai_conversation: nil,
    on_new_message: nil,
    front_user:
  )
    super(model:, ai_conversation:, on_new_message:)
    @front_user = front_user
  end

  def system_directive
    File.read("#{Rails.root}/config/assistant_instructions_data_analyst.md")
  end

  def client
    AI_CLIENT.client
  end

  def tools
    [
      Tools::Math.new,
      Tools::Database.new(connection_string: APP_CONFIG["dashboard_db_connection"]),
      Tools::Chart.new,
      Tools::AlertCreator.new(front_user: @front_user)
    ]
  end

  # def after_initialize
  #   clean_conversation
  # end

  # # TODO: investigate why this is needed
  # # If not I get error:
  # # {
  # # "message": "Invalid value for 'content': expected a string, got null.",
  # # "type": "invalid_request_error",
  # # "param": "messages.[4].content",
  # # "code": null
  # # }
  # def clean_conversation
  #   @conversation.messages.each do |message|
  #     message.data[:content] = "" if message.content.nil?
  #   end
  # end
end
