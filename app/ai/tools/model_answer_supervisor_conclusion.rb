class Tools::ModelAnswerSupervisorConclusion < LangMini::Tool
  def initialize(conversation:)
    @conversation = conversation
  end

  def tool_description_path
    "#{__dir__}/model_answer_supervisor_conclusion.json"
  end

  def supervisor_conclusion(result:, content:)
    puts ">>>> ModelAnswerSupervisorConclusion: conversation_id: #{@conversation.id}, result: #{result}, content: #{content}"

    if !result
      lang_mini_message = LangMini::Message.from_hash({
        role: "assistant",
        content: content
      })
      message = Conversation::LangMiniMessageToAppMessage.perform(lang_mini_message)
      message.assistant_name = "ModelAnswerSupervisorAssistant"
      @conversation.add_message(message)
    end
  end
end
