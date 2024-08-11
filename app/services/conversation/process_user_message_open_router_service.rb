class Conversation::ProcessUserMessageOpenRouterService < Service
  def perform(conversation, role, content, model = nil)
    @conversation = conversation
    @ai_conversation = Conversation::ConversationToAIConversationService.perform(@conversation)
    @ai_conversation.reset_new_messages
    @assistant =
      Assistants::DataAnalyst.new(
        ai_conversation: @ai_conversation,
        model: model,
        on_new_message: method(:on_new_message),
        front_user: @conversation.front_user
      )

    @assistant.completion({ role:, content: })
  end

  def on_new_message(ai_message)
    puts ">>>> on_new_message: #{ai_message}"
    message = Conversation::AIMessageToAppMessage.perform(ai_message)
    @conversation.add_message(message)
  end
end
