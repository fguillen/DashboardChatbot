require "test_helper"

class Conversation::ConversationToLangMiniConversationServiceTest < ActiveSupport::TestCase
  def test_perform
    lang_ai_message_1 = LangMini::Message.from_hash({role: "user", content: "MESSAGE_1"})
    lang_ai_message_2 = LangMini::Message.from_hash({role: "assistant", content: "MESSAGE_2"})
    message_1 = Conversation::LangMiniMessageToAppMessage.perform(lang_ai_message_1)
    message_2 = Conversation::LangMiniMessageToAppMessage.perform(lang_ai_message_2)

    conversation = FactoryBot.create(:conversation)
    conversation.add_message(message_1)
    conversation.add_message(message_2)

    result = Conversation::ConversationToLangMiniConversationService.perform(conversation)

    assert_equal("LangMini::Conversation", result.class.name)
    assert_equal(2, result.messages.count)
    assert_equal("LangMini::Message", result.messages.first.class.name)
    assert_equal("user", result.messages.first.role)
    assert_equal("MESSAGE_1", result.messages.first.content)
  end
end
