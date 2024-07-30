require "test_helper"

class Conversation::ProcessUserMessageOpenRouterServiceTest < ActiveSupport::TestCase
  test "should create new messages based on the conversation" do
    conversation = FactoryBot.create(:conversation)
    message_content = "Hello Model!"
    new_message = Conversation::ProcessUserMessageOpenRouterService.perform(conversation, "user", message_content)

    puts ">>>> new_message: #{new_message}"

    conversation.reload

    puts ">>>> conversation.messages: #{conversation.messages}"

    assert_equal(3, conversation.messages.count)
    assert_equal("assistant", conversation.messages.in_order.last.role)
    # assert_equal("Hello! How can I assist you today?", conversation.messages.in_order.last.content)
  end
end
