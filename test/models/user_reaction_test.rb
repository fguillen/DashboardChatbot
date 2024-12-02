require "test_helper"

class UserReactionTest < ActiveSupport::TestCase
  def test_fixture_is_valid
    assert FactoryBot.create(:user_reaction).valid?
  end

  def test_uuid_on_create
    message = FactoryBot.create(:message)
    user_reaction = FactoryBot.build(:user_reaction, message:)
    assert_nil(user_reaction.uuid)

    user_reaction.save!
    assert_not_nil(user_reaction.uuid)
  end

  def test_primary_key
    user_reaction = FactoryBot.create(:user_reaction)

    assert_equal(user_reaction, UserReaction.find(user_reaction.uuid))
  end

  def test_relations
    front_user = FactoryBot.create(:front_user)
    message = FactoryBot.create(:message, front_user:)
    user_reaction = FactoryBot.create(:wuser_reaction, message:)
    user_favorite = FactoryBot.create(:user_favorite, user_reaction:)

    assert_equal(message, user_reaction.message)
    assert_equal(front_user, user_reaction.front_user)
    assert_equal(user_favorite, user_reaction.user_favorite)
  end

  def test_log_book_events
    message = FactoryBot.create(:message)
    user_reaction = FactoryBot.build(:user_reaction, explanation: "EXPLANATION", message: message)

    assert_difference("LogBook::Event.count", 1) do
      user_reaction.save!
    end

    assert_difference("LogBook::Event.count", 1) do
      user_reaction.update!(explanation: "NEW_EXPLANATION")
    end
  end

  def test_enum_kind
    user_reaction = FactoryBot.create(:user_reaction, kind: "positive")
    assert_equal("positive", user_reaction.kind)
    assert(user_reaction.positive?)

    user_reaction.update!(kind: "negative")
    assert_equal("negative", user_reaction.kind)
    assert(user_reaction.negative?)
  end

  def test_scope_order_by_recent
    user_reaction_1 = FactoryBot.create(:user_reaction, created_at: "2021-04-01")
    user_reaction_2 = FactoryBot.create(:user_reaction, created_at: "2021-04-03")
    user_reaction_3 = FactoryBot.create(:user_reaction, created_at: "2021-04-02")

    assert_primary_keys([user_reaction_2, user_reaction_3, user_reaction_1], UserReaction.order_by_recent)
  end

  def test_uniqueness_by_message
    message = FactoryBot.create(:message)
    user_reaction_1 = FactoryBot.create(:user_reaction, message:)
    assert(user_reaction_1.valid?)

    user_reaction_2 = FactoryBot.build(:user_reaction, message:)
    assert_not(user_reaction_2.valid?)
  end

  def test_origianl_prompt
    message_1 = FactoryBot.create(:message, order: 1, role: "user", content: "MESSAGE_1")
    message_2 = FactoryBot.create(:message, order: 2, role: "assistant", content: "MESSAGE_2")
    message_3 = FactoryBot.create(:message, order: 3, role: "user", content: "MESSAGE_3")
    message_4 = FactoryBot.create(:message, order: 4, role: "tool", content: "MESSAGE_4")
    message_5 = FactoryBot.create(:message, order: 5, role: "assistant", content: "MESSAGE_5")
    message_6 = FactoryBot.create(:message, order: 6, role: "user", content: "MESSAGE_6")

    conversation = FactoryBot.create(:conversation, messages: [message_1, message_2, message_3, message_4, message_5, message_6])

    user_reaction = FactoryBot.create(:user_reaction, message: message_5)

    assert_equal("MESSAGE_3", user_reaction.original_prompt)
  end
end
