require "test_helper"

class Conversation::LangMiniMessageToAppMessageTest < ActiveSupport::TestCase
  def setup
    LangMini.logger.level = Logger::WARN
  end

  def test_perform_with_tool_call
    completion_raw = JSON.parse(read_fixture("lang_mini/completion_tool_call_sum_1.json"), symbolize_names: true)
    completion = LangMini::Completion.new(completion_raw)
    lang_mini_message = LangMini::Message.from_completion(completion)
    message = Conversation::LangMiniMessageToAppMessage.perform(lang_mini_message)

    assert_equal("assistant", message.role)
    assert_nil(message.content)
    assert_equal(completion_raw[:choices][0][:message], message.raw)
    assert_equal(completion_raw, message.completion_raw)
    assert_equal("call_Z79bsWuK4twmLNx9smS7M1bI", message.tool_calls[0][:id])
    assert_nil(message.tool_call_id)
    assert_equal("openai/gpt-4o", message.model)
  end

  def test_perform_with_tool_respose
    message_raw = JSON.parse(read_fixture("lang_mini/tool_result.json"), symbolize_names: true)
    lang_mini_message = LangMini::Message.from_hash(message_raw)
    message = Conversation::LangMiniMessageToAppMessage.perform(lang_mini_message)

    assert_equal("tool", message.role)
    assert_equal("5", message.content)
    assert_equal(message_raw, message.raw)
    assert_nil(message.completion_raw)
    assert_nil(message.tool_calls)
    assert_equal("call_Z79bsWuK4twmLNx9smS7M1bI", message.tool_call_id)
    assert_nil(message.model)
  end
end
