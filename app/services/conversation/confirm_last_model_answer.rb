class Conversation::ConfirmLastModelAnswer < Service
  def perform(conversation:)
    puts ">>>> Conversation::ConfirmLastModelAnswer.perform"
    assistant =
      Assistants::ModelAnswerSupervisorAssistant.new(
        conversation:
      )

    message = LangMini::Message.from_hash({
      role: "user",
      content: "Confirm that the last answer from the model is correct."
    })
    new_messages = assistant.completion(message:)

    content = new_messages.last.content
    content
  end
end
