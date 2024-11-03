class Assistants::ModelAnswerSupervisorAssistant < LangMini::Assistant
  def system_directive
    File.read("#{Rails.root}/config/assistant_instructions_model_answer_supervisor_assistant.md")
  end

  def initialize(
    model: LangMini::DEFAULT_MODEL,
    conversation:,
    on_new_message: nil
  )
    @app_conversation = conversation
    lang_mini_conversation = Conversation::ConversationToLangMiniConversationService.perform(@app_conversation)
    super(model:, conversation: lang_mini_conversation, on_new_message:, client: self.client)
  end

  def client
    AI_CLIENT
  end

  def tools
    [
      Tools::ModelAnswerSupervisorConclusion.new(conversation: @app_conversation),
    ]
  end
end
