require "test_helper"

class LangMini::ConversationTest < ActiveSupport::TestCase
  test "should create new messages based on the conversation" do
    conversation = LangMini::Conversation.new
    ai_message = LangMini::Message.from_hash({ role: "user", content: "Hello Model!" })
    conversation.add_message(ai_message)

    puts ">>>> conversation.messages: #{conversation.messages}"
    puts ">>>> conversation.messages_data: #{conversation.messages_data}"
  end

  test "should reset new messages" do
    message = FactoryBot.create(:message)
    ai_message = LangMini::Message.from_hash(message)

    conversation = LangMini::Conversation.new
    conversation.add_message(ai_message)

    puts ">>>> conversation.messages_data: #{conversation.messages_data}"
  end
end
