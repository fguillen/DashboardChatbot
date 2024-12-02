class Conversation::ConversationToLangMiniConversationService < Service
  def perform(conversation)
    Conversation::MessagesToLangMiniConversationService.perform(messages: conversation.messages.in_order)
  end
end
