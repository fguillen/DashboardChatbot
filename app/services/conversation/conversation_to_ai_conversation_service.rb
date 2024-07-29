class Conversation::ConversationToAIConversationService < Service
  def perform(conversation)
    ai_conversation = AI::Conversation.new

    conversation.messages.in_order.each do |app_message|
      ai_message = AI::Message.from_app_message(app_message)
      ai_conversation.add_message(ai_message)
    end

    ai_conversation
  end
end
