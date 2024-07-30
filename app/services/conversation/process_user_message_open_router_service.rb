class Conversation::ProcessUserMessageOpenRouterService < Service
  def perform(conversation, role, content)
    @ai_conversation = Conversation::ConversationToAIConversationService.perform(conversation)
    @ai_conversation.reset_new_messages
    @assistant = Assistants::DataAnalyst.new(ai_conversation: @ai_conversation)

    new_ai_messages = @assistant.completion({ role:, content: })

    new_ai_messages.each do |ai_message|
      puts ">>>>> new_ai_message: #{ai_message.inspect}"

      conversation.add_message(
        role: ai_message.data[:role],
        content: ai_message.data[:content],
        meta: ai_message.meta,
        tool_calls: ai_message.data[:tool_calls],
        tool_call_id: ai_message.data[:tool_call_id]
      )
    end

    # error = nil

    # begin
    #   assistant(conversation).run(auto_tool_execution: true) # TODO: Remove auto_tool_execution, it is danger
    # rescue StandardError => e
    #   error = e.message
    #   puts ">>>> assistant.run.error: #{error}"
    #   puts e.backtrace.join("\n")
    #   Rollbar.error(e, { conversation_id: conversation.id })
    # end

    # puts ">>>> Messages :: INI"
    # puts ">>>> #{assistant(conversation).thread.messages}"
    # puts ">>>>> to hash"
    # puts ">>>> #{assistant(conversation).thread.messages.map(&:to_hash)}"
    # puts ">>>> Messages :: END"

    # new_messages =
    #   assistant(conversation).thread.messages[conversation.messages.count..].map(&:to_hash).map do |openai_message|
    #     puts ">>>> new_message: #{openai_message}"
    #     conversation.add_message(**openai_message)
    #   end

    # if error.present?
    #   message_error = conversation.add_message(role: "system", content: error)
    #   new_messages << message_error
    # end

    new_ai_messages.last
  end

  private

  # def assistant(conversation)
  #   return @assistant if @assistant.present?

  #   @assistant = AI:Assistant.new(conversation: ai_conversation(conversation))
  # end

  # def ai_conversation(conversation)
  #   return @ai_conversation if @ai_conversation.present?

  #   @ai_conversation = Conversation::ConversationToAiConversationService.perform(conversation)
  # end

  # def add_instructions_if_no_present
  #   if @conversation.messages.blank?
  #     @conversation.add_message(role: "system", content: File.read("#{Rails.root}/config/assistant_instructions.md"))
  #   end
  # end

end
