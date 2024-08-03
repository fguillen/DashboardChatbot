require "test_helper"

class Conversation::ProcessUserMessageOpenRouterServiceTest < ActiveSupport::TestCase
  test "should create new messages based on the conversation" do
    conversation = FactoryBot.create(:conversation)
    message_content = "Hello Model!"
    new_messages = Conversation::ProcessUserMessageOpenRouterService.perform(conversation, "user", message_content)

    puts ">>>> new_messages: #{new_messages}"

    conversation.reload

    puts ">>>> conversation.messages: #{conversation.messages}"

    assert_equal(3, new_messages.count)
    assert_equal(3, conversation.messages.count)
    assert_equal("assistant", conversation.messages.in_order.last.role)
    # assert_equal("Hello! How can I assist you today?", conversation.messages.in_order.last.content)
  end

  test "tools" do
    conversation = FactoryBot.create(:conversation)
    message_content = "sum the numbers 2 and 3. use the tools: Tools-Math__sum"
    new_messages = Conversation::ProcessUserMessageOpenRouterService.perform(conversation, "user", message_content)

    puts ">>>> new_messages: #{new_messages.inspect}"

    conversation.reload

    puts ">>>> conversation.messages: #{conversation.messages.inspect}"

    assert_equal(3, new_messages.count)
    assert_equal(3, conversation.messages.count)
    assert_equal("assistant", conversation.messages.in_order.last.role)
    # assert_equal("Hello! How can I assist you today?", conversation.messages.in_order.last.content)
  end

end