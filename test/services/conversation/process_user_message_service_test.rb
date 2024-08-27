require "test_helper"

class Conversation::ProcessUserMessageServiceTest < ActiveSupport::TestCase
  def test_should_create_new_messages_based_on_the_conversation
    conversation = FactoryBot.create(:conversation)
    message_content = "Hello Model!"
    new_messages =
      Conversation::ProcessUserMessageService.perform(
        conversation:,
        content: message_content,
        role: "user"
      )

    puts ">>>> new_messages: #{new_messages}"

    conversation.reload

    puts ">>>> conversation.messages: #{conversation.messages}"

    assert_equal(3, new_messages.count)
    assert_equal(3, conversation.messages.count)
    assert_equal("assistant", conversation.messages.in_order.last.role)
    # assert_equal("Hello! How can I assist you today?", conversation.messages.in_order.last.content)
  end

  def test_tools
    conversation = FactoryBot.create(:conversation)
    message_content = "sum the numbers 2 and 3. use the tools: Tools-Math__sum"
    new_messages = Conversation::ProcessUserMessageService.perform(conversation, "user", message_content)

    puts ">>>> new_messages: #{new_messages.inspect}"

    conversation.reload

    puts ">>>> conversation.messages: #{conversation.messages.inspect}"

    assert_equal(3, new_messages.count)
    assert_equal(3, conversation.messages.count)
    assert_equal("assistant", conversation.messages.in_order.last.role)
    # assert_equal("Hello! How can I assist you today?", conversation.messages.in_order.last.content)
  end

end
