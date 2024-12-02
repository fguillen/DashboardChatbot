require "test_helper"

class UserFavorites::ModelMentalProcessGeneratorTest < ActiveSupport::TestCase
  def test_perform
    lang_mini_messages =
      read_json("/user_favorites/conversation_to_generate_model_mental_process.json")
        .map { |e| LangMini::Message.from_hash(e) }

    messages =
      lang_mini_messages.map do |lang_mini_message|
        Conversation::LangMiniMessageToAppMessage.perform(lang_mini_message)
      end

    mental_process = UserFavorites::ModelMentalProcessGenerator.perform(messages:)

    assert(mental_process.include?("1."))
    assert(mental_process.include?("2."))
  end
end
