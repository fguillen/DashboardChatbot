require "test_helper"

class Conversation::ConfirmLastModelAnswerTest < ActiveSupport::TestCase
  def test_should_create_new_messages_based_on_the_conversation
    conversation = FactoryBot.create(:conversation)
    conversation.add_message(FactoryBot.create(:message, role: "user", content: "How much is 2 + 2?"))
    conversation.add_message(FactoryBot.create(:message, role: "assistant", content: "The sum of 2 + 2 is 4."))

    new_messages =
      Conversation::ConfirmLastModelAnswer.perform(
        conversation:
      )

    puts ">>>> new_messages: #{new_messages}"

    conversation.reload

    puts ">>>> conversation.messages: #{conversation.messages}"

  end
end
