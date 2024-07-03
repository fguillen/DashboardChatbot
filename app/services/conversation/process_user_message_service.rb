class Conversation::ProcessUserMessageService < Service
  def perform(conversation, role, content)
    Langchain.logger.level = :debug

    puts ">>>> assistant.llm.defaults: #{assistant(conversation).llm.defaults}"
    puts ">>>> role: #{role}"

    add_instructions_if_no_present(conversation)

    assistant(conversation).add_message(role: role, content: content)
    assistant(conversation).run(auto_tool_execution: true) # TODO: Remove auto_tool_execution, it is danger

    puts ">>>> messages"
    puts ">>>> #{assistant(conversation).thread.messages.map(&:to_hash)}"

    new_messages =
      assistant(conversation).thread.messages[conversation.messages.count..].map(&:to_hash).map.with_index do |openai_message, index|
        puts ">>>> new_message: #{openai_message}"
        conversation.messages.create!(openai_message.merge(order: conversation.messages.maximum(:order) + 1))
      end

    new_messages
  end

  private

  def thread(conversation)
    return @thread if @thread.present?

    @thread = Conversation::ConversationToThreadService.perform(conversation)
  end

  def assistant(conversation)
    return @assistant if @assistant.present?

    @assistant = Langchain::Assistant.new(
      llm: llm,
      thread: thread(conversation),
      tools: [
        tool_database
      ]
    )
  end

  def llm
    @llm ||=
      Langchain::LLM::OpenAI.new(
        api_key: APP_CONFIG["openai_api_key"],
        default_options: {
          temperature: 0.0,
          chat_completion_model_name: "gpt-4o"
        }
      )
  end

  def tool_database
    @tool_database ||= Langchain::Tool::Database.new(connection_string: APP_CONFIG["dashboard_db_connection"])
  end

  def add_instructions_if_no_present(conversation)
    if conversation.messages.blank?
      conversation.messages.create!(role: "system", content: File.read("#{Rails.root}/config/assistant_instructions.md"), order: 0)
    end
  end

end
