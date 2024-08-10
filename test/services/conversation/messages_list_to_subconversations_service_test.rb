require "test_helper"

class Conversation::MessagesListToSubconversationsServiceTest < ActiveSupport::TestCase
  test "should create subconversations" do
    conversation = FactoryBot.create(:conversation)

    message_1 = conversation.add_message(role: "user")
    message_2 = conversation.add_message(role: "assistant")
    message_3 = conversation.add_message(role: "user")
    message_4 = conversation.add_message(role: "assistant")
    message_5 = conversation.add_message(role: "assistant")
    message_6 = conversation.add_message(role: "user")
    message_7 = conversation.add_message(role: "user")
    message_8 = conversation.add_message(role: "assistant")

    result = Conversation::MessagesListToSubconversationsService.perform(conversation)

    assert_equal(4, result.count)
    assert_equal([message_1, message_2], result[0])
    assert_equal([message_3, message_4, message_5], result[1])
    assert_equal([message_6], result[2])
    assert_equal([message_7, message_8], result[3])
  end

  test "when first message is not user should create subconversations" do
    conversation = FactoryBot.create(:conversation)

    message_1 = conversation.add_message(role: "assistant")
    message_2 = conversation.add_message(role: "user")
    message_3 = conversation.add_message(role: "assistant")

    result = Conversation::MessagesListToSubconversationsService.perform(conversation)

    assert_equal(2, result.count)
    assert_equal([message_1], result[0])
    assert_equal([message_2, message_3], result[1])
  end
end
