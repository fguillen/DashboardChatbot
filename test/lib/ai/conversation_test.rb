require "test_helper"

class AI::ConversationTest < ActiveSupport::TestCase
  test "should create new messages based on the conversation" do
    conversation = AI::Conversation.new
    ai_message = AI::Message.from_message({ role: "user", content: "Hello Model!" })
    conversation.add_message(ai_message)

    puts ">>>> conversation.messages: #{conversation.messages}"
    puts ">>>> conversation.messages_data: #{conversation.messages_data}"
  end

  test "should reset new messages" do
    message = FactoryBot.create(:message)
    ai_message = AI::Message.from_message(message)

    conversation = AI::Conversation.new
    conversation.add_message(ai_message)

    puts ">>>> conversation.messages_data: #{conversation.messages_data}"
  end
end
