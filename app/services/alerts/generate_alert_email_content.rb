class Alerts::GenerateAlertEmailContent < Service
  def perform(alert:, conversation:)
    ai_conversation = Conversation::ConversationToLangMiniConversationService.perform(conversation)
    assistant =
      Assistants::ConversationAssistant.new(
        ai_conversation: ai_conversation,
        model: alert.model
      )

    new_messages =
      assistant.completion({
        role: "user",
        content: "Summarize the conversation and provide an email body. Be sure the main question of the user is present and the required data is expressed in detail. Only respond with the content of the email body that is going to be sent to the user."
      })

    content = new_messages.last.content
    content
  end
end
