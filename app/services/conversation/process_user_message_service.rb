class Conversation::ProcessUserMessageService < Service
  def perform(conversation:, content:, role: "user", model: LangMini::DEFAULT_MODEL)
    @conversation = conversation
    lang_mini_conversation = Conversation::ConversationToLangMiniConversationService.perform(@conversation)
    lang_mini_conversation.reset_new_messages
    assistant =
      Assistants::DataAnalyst.new(
        lang_mini_conversation: lang_mini_conversation,
        model: model,
        on_new_message: method(:on_new_message),
        front_user: @conversation.front_user
      )

    lang_mini_message = LangMini::Message.from_hash({ role:, content: })
    assistant.completion(message: lang_mini_message)
  end

  def on_new_message(lang_mini_message)
    puts ">>>> on_new_message: #{lang_mini_message}"
    message = Conversation::LangMiniMessageToAppMessage.perform(lang_mini_message)
    @conversation.add_message(message)
  end
end
