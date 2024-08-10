class Alerts::ProcessAlertService < Service
  def perform(alert)
    @ai_conversation = AI::Conversation.new
    @ai_conversation.reset_new_messages
    # set_context(alert.context)
    @assistant = Assistants::DataAnalyst.new(ai_conversation: @ai_conversation, model: alert.model)

    new_messages = @assistant.completion({ role: "user", content: alert.prompt})
  end

  # def set_context(context)
  #   ai_message =
  #     AI::Message.from_hash({
  #       "role" => "system",
  #       "content" => context
  #     })

  #   @ai_conversation.add_message(ai_message)
  # end

  def on_new_message(ai_message)
    puts ">>>> on_new_message: #{ai_message}"

    @ai_conversation.add_message(ai_message)
  end
end
