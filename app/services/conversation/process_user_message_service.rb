class Conversation::ProcessUserMessageService < Service
  def perform(conversation, role, content)
    Langchain.logger.level = :debug

    add_instructions_if_no_present(conversation)

    puts ">>>> assistant.llm.defaults: #{assistant(conversation).llm.defaults}"
    puts ">>>> role: #{role}"

    assistant(conversation).add_message(role:, content:)

    error = nil

    begin
      assistant(conversation).run(auto_tool_execution: true) # TODO: Remove auto_tool_execution, it is danger
    rescue StandardError => e
      error = e.message
      puts ">>>> assistant.run.error: #{error}"
      puts e.backtrace.join("\n")
      Rollbar.error(e, { conversation_id: conversation.id })
    end

    puts ">>>> Messages :: INI"
    puts ">>>> #{assistant(conversation).thread.messages.map(&:to_hash)}"
    puts ">>>> Messages :: END"

    new_messages =
      assistant(conversation).thread.messages[conversation.messages.count..].map(&:to_hash).map do |openai_message|
        puts ">>>> new_message: #{openai_message}"
        conversation.add_message(**openai_message)
      end

    if error.present?
      message_error = conversation.add_message(role: "system", content: error)
      new_messages << message_error
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
        tool_database,
        tool_chart
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

  def tool_chart
    @tool_chart ||= Langchain::Tool::Chart.new()
  end

  def add_instructions_if_no_present(conversation)
    if conversation.messages.blank?
      conversation.add_message(role: "system", content: File.read("#{Rails.root}/config/assistant_instructions.md"))
    end
  end

end
