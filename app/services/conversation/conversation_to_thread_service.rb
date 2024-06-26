class Conversation::ConversationToThreadService < Service
  def perform(conversation)
    thread = Langchain::Thread.new

    conversation.messages.in_order.each do |message|
      openai_message =
        Langchain::Messages::OpenAIMessage.new(
          role: message.role,
          content: message.content,
          tool_calls: message.tool_calls,
          tool_call_id: message.tool_call_id
        )
      thread.add_message(openai_message)
    end

    thread
  end
end
