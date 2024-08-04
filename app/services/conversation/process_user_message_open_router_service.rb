class Conversation::ProcessUserMessageOpenRouterService < Service
  def perform(conversation, role, content, model = nil)
    @conversation = conversation
    @ai_conversation = Conversation::ConversationToAIConversationService.perform(@conversation)
    @ai_conversation.reset_new_messages
    @assistant = Assistants::DataAnalyst.new(ai_conversation: @ai_conversation, model: model, on_new_message: method(:on_new_message))
    @new_messages = []

    @assistant.completion({ role:, content: })

    @new_messages
  end

  def on_new_message(ai_message)
    puts ">>>> on_new_message: #{ai_message}"

    new_message =
      @conversation.add_message(
        role: ai_message.data[:role],
        content: ai_message.data[:content],
        raw: ai_message.raw,
        tool_calls: ai_message.data[:tool_calls]&.map(&:to_hash),
        tool_call_id: ai_message.data[:tool_call_id],
        model: @assistant.model
      )

    @new_messages << new_message
  end
end
