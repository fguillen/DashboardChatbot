class UserFavorites::ModelMentalProcessGenerator < Service
  def perform(messages:)
    answer = raw_answer(messages)
    steps = extract_steps(answer)

    steps
  end

  private

  def raw_answer(messages)
    lang_mini_conversation = Conversation::MessagesToLangMiniConversationService.perform(messages:)
    assistant =
      Assistants::ConversationAssistant.new(
        lang_mini_conversation:
      )

    lang_mini_message = LangMini::Message.from_hash({
      role: "user",
      content: prompt
    })

    new_messages = assistant.completion(message: lang_mini_message)
    content = new_messages.last.content
    content
  end

  def extract_steps(content)
    Rails.logger.debug("UserFavorites::ModelMentalProcessGenerator.raw_content: #{content}")
    steps = content.scan(/```markdown(.*)```/m).first.first.strip
    Rails.logger.debug("UserFavorites::ModelMentalProcessGenerator.steps: #{steps}")
    steps
  end

  def prompt
    <<~EOS
      Can you explain your reasoning step by step for generating that response?
      Please structure your answer as a numbered list where
      each step describes a specific part of your reasoning process.
      Detail the steps in markdown format.
      Example "These are the steps: ```mardown steps```"
    EOS
  end
end
