require "test_helper"

class UserFavorites::UserFavoriteCreatorTest < ActiveSupport::TestCase
  def test_perform
    message_1 = FactoryBot.create(:message, order: 1, role: "user", content: "MESSAGE_1")
    message_2 = FactoryBot.create(:message, order: 2, role: "assistant", content: "MESSAGE_2")
    message_3 = FactoryBot.create(:message, order: 3, role: "user", content: "MESSAGE_3")
    message_4 = FactoryBot.create(:message, order: 4, role: "tool", content: "MESSAGE_4")
    message_5 = FactoryBot.create(:message, order: 5, role: "assistant", content: "MESSAGE_5")
    message_6 = FactoryBot.create(:message, order: 6, role: "user", content: "MESSAGE_6")

    conversation = FactoryBot.create(:conversation, messages: [message_1, message_2, message_3, message_4, message_5, message_6])
    user_reaction = FactoryBot.create(:user_reaction, message: message_5)

    UserFavorites::ModelMentalProcessGenerator
      .expects(:perform)
      .with(messages: [message_1, message_2, message_3, message_4, message_5])
      .returns("MODEL_MENTAL_PROCESS")

    UserFavorites::GenerateEmbeddings
      .expects(:perform)
      .with("MESSAGE_3")
      .returns(Array.new(384, 0))

    assert_difference("UserFavorite.count", 1) do
      UserFavorites::UserFavoriteCreator.perform(user_reaction:)
    end

    user_favorite = UserFavorite.last

    assert_equal("MESSAGE_3", user_favorite.prompt)
    assert_equal("MODEL_MENTAL_PROCESS", user_favorite.model_mental_process)
    assert_equal(384, user_favorite.prompt_embedding.size)
    assert_equal(0, user_favorite.prompt_embedding.first)
    assert_equal(user_reaction, user_favorite.user_reaction)
  end
end
