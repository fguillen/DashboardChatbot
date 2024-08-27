class Conversation::LangMiniMessageToAppMessage < Service
  def perform(lang_mini_message, model: nil)
    Message.new(
      role: lang_mini_message.role,
      content: lang_mini_message.content,
      raw: lang_mini_message.data,
      completion_raw: lang_mini_message.completion&.data,
      tool_calls: lang_mini_message.tool_calls,
      tool_call_id: lang_mini_message.tool_call_id,
      model: model || lang_mini_message.model
    )
  end
end
