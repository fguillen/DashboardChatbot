class Conversation::AIMessageToAppMessage < Service
  def perform(ai_message, model: nil)
    Message.new(
      role: ai_message.role,
      content: ai_message.content,
      raw: ai_message.raw,
      tool_calls: ai_message.tool_calls,
      tool_call_id: ai_message.tool_call_id,
      model: model || ai_message.model
    )
  end
end
