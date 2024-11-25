require "test_helper"

class UserReactionTest < ActiveSupport::TestCase
  def test_fixture_is_valid
    assert FactoryBot.create(:user_reaction).valid?
  end

  def test_uuid_on_create
    user_reaction = FactoryBot.build(:user_reaction)
    assert_nil(user_reaction.uuid)

    user_reaction.save!

    assert_not_nil(user_reaction.uuid)
  end

  def test_primary_key
    user_reaction = FactoryBot.create(:user_reaction)

    assert_equal(user_reaction, UserReaction.find(user_reaction.uuid))
  end

  def test_relations
    message = FactoryBot.create(:message)
    user_reaction = FactoryBot.create(:user_reaction, message: message)

    assert_equal(message, user_reaction.message)
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

    assert_primary_keys([user_reaction_2, user_reaction_3, user_reaction_1], FrontUser.order_by_recent)
  end
end
