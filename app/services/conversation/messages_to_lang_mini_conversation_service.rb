class Conversation::MessagesToLangMiniConversationService < Service
  def perform(messages:)
    lang_mini_conversation = LangMini::Conversation.new
    messages.each do |message|
      lang_mini_message = LangMini::Message.from_hash(message.raw)
      lang_mini_conversation.add_message(lang_mini_message)
    end

    lang_mini_conversation
  end
end
