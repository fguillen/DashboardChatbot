class Assistants::ConversationAssistant < AI::Assistant
  # def after_initialize
  #   clean_conversation
  # end

  # def clean_conversation
  #   @conversation.messages =
  #     @conversation.messages.filter do |m|
  #       m.role != "tool" && m.content.present?
  #     end
  # end

  def system_directive
    File.read("#{Rails.root}/config/assistant_instructions_conversation_assistant.md")
  end

  def client
    AI_CLIENT.client
  end
end
