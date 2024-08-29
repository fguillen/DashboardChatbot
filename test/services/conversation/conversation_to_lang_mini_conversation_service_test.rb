require "test_helper"

class Conversation::ConversationToLangMiniConversationServiceTest < ActiveSupport::TestCase
  def test_perform
    conversation = FactoryBot.create(:conversation)
    conversation.messages.create(role: "user", content: "MESSAGE_1")
    conversation.messages.create(role: "assistant", content: "MESSAGE_2")

    result = Conversation::ConversationToLangMiniConversationService.perform(conversation)

    assert_equal("LangMini::Conversation", result.class.name)
    assert_equal(2, result.messages.count)
    assert_equal("LangMini::Message", result.messages.first.class.name)
    assert_equal("user", result.messages.first.role)
    assert_equal("MESSAGE_1", result.messages.first.content)
  end
end
