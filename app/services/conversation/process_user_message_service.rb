class Conversation::ProcessUserMessageService < Service
  def perform(conversation:, content:, role: "user", model: nil)
    @conversation = conversation
    @new_messages = []
    model = model || conversation.front_user.client.default_model || LangMini::DEFAULT_MODEL
    system_directive = parse_system_directive(conversation.front_user.client.agent_instructions)

    lang_mini_conversation = Conversation::ConversationToLangMiniConversationService.perform(@conversation)
    lang_mini_conversation.reset_new_messages
    assistant =
      Assistants::DataAnalyst.new(
        lang_mini_conversation:,
        model: ,
        system_directive:,
        on_new_message: method(:on_new_message),
        front_user: @conversation.front_user
      )

    lang_mini_message = LangMini::Message.from_hash({ role:, content: })
    assistant.completion(message: lang_mini_message)

    @new_messages
  end

  def on_new_message(lang_mini_message)
    puts ">>>> on_new_message: #{lang_mini_message.inspect}"
    message = Conversation::LangMiniMessageToAppMessage.perform(lang_mini_message)
    @conversation.add_message(message)
    @new_messages.push(message)
  end

  private

  def parse_system_directive(system_directive)
    return nil if system_directive.nil?

    template =
      ERB.new(
        system_directive
      )

    current_year = Date.today.year
    current_date = Date.today.strftime("%Y-%m-%d")

    template.result_with_hash(current_year:, current_date:)
  end
end
