require "test_helper"

class AI::ConversationTest < ActiveSupport::TestCase
  test "should create new messages based on the conversation" do
    conversation = AI::Conversation.new
    ai_message = AI::Message.from_message({ role: "user", content: "Hello Model!" })
    conversation.add_message(ai_message)

    puts ">>>> conversation.messages: #{conversation.messages}"
    puts ">>>> conversation.messages_data: #{conversation.messages_data}"
  end
end
