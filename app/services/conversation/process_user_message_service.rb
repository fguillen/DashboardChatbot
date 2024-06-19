class Conversation::ProcessUserMessageService < Service
  def perform(conversation, role, content)
    Langchain.logger.level = :debug

    puts ">>>> role: #{role}"

    assistant(conversation).add_message(role: role, content: content)
    assistant(conversation).run(auto_tool_execution: true) # TODO: Remove auto_tool_execution, it is danger

    puts ">>>> messages"
    puts ">>>> #{assistant(conversation).thread.messages.map(&:to_hash)}"

    new_messages =
      assistant(conversation).thread.messages[conversation.messages.count..].map(&:to_hash).map.with_index do |openai_message, index|
        puts ">>>> new_message: #{openai_message}"
        conversation.messages.create(openai_message.merge(order: index + conversation.messages.count))
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
      instructions: "You are a data analist that is quering a database to answer the user's requests",
      tools: [
        tool_database
      ]
    )
  end

  def llm
    @llm ||= Langchain::LLM::OpenAI.new(api_key: APP_CONFIG["openai_api_key"])
  end

  def tool_database
    @tool_database ||= Langchain::Tool::Database.new(connection_string: APP_CONFIG["dashboard_db_connection"])
  end


# Building the assistant



# def execute_request(request, assistant)
#   puts ">>>> request: #{request}"
#   assistant.add_message content: request
#   assistant.run auto_tool_execution: true
#   puts assistant.thread.messages.map(&:to_hash)
# end

# llm = Langchain::LLM::OpenAI.new(api_key: ENV["OPENAI_API_KEY"])
# thread = Langchain::Thread.new
# assistant = Langchain::Assistant.new(
#   llm: llm,
#   thread: thread,
#   instructions: "You are a data analist that is quering a database to answer the user's requests",
#   tools: [
#     Langchain::Tool::Database.new(connection_string: "sqlite://#{db_file_path}")
#   ]
# )
end
