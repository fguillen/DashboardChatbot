class Alerts::GenerateAlertEmailContent < Service
  PROMPT = <<~EOS
    Summarize the conversation and provide an email body.
    Be sure the main question of the user is present and the required data is expressed
    in detail.

    Only respond with the content of the email body that is going to be sent to the user.

    Here is an example:

    Dear user,

    In answer to your request:

    - [REQUEST FROM THE USER]

    Here is the answer:

    [ANSWER]

    The query, or queries I have executed are:

    [QUERY]

    Hope this helps!

    Sincerely,

    Your AI Data Analyst
  EOS

  def perform(alert:, conversation:)
    lang_mini_conversation = Conversation::ConversationToLangMiniConversationService.perform(conversation)
    assistant =
      Assistants::ConversationAssistant.new(
        lang_mini_conversation:,
        model: alert.model
      )

    lang_mini_message = LangMini::Message.from_hash({
      role: "user",
      content: PROMPT
    })

    new_messages =
      assistant.completion(
        message: lang_mini_message
      )

    content = new_messages.last.content
    content
  end
end
