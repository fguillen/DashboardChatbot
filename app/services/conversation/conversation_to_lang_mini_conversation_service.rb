class Conversation::ConversationToLangMiniConversationService < Service
  def perform(conversation)
    lang_mini_conversation = LangMini::Conversation.new

    conversation.messages.in_order.each do |message|
      lang_mini_message = LangMini::Message.from_hash(message.to_hash)
      lang_mini_conversation.add_message(lang_mini_message)
    end

    lang_mini_conversation
  end
end
