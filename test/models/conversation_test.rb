require "test_helper"

class ConversationTest < ActiveSupport::TestCase
  def test_fixture_is_valid
    assert FactoryBot.create(:conversation).valid?
  end

  def test_validations
    conversation = FactoryBot.build(:conversation)
    assert(conversation.valid?)

    conversation = FactoryBot.build(:conversation, title: nil)
    refute(conversation.valid?)

    conversation = FactoryBot.build(:conversation, front_user: nil)
    refute(conversation.valid?)
  end

  def test_uuid_on_create
    conversation = FactoryBot.build(:conversation)
    assert_nil(conversation.uuid)

    conversation.save!

    assert_not_nil(conversation.uuid)
  end

  def test_primary_key
    conversation = FactoryBot.create(:conversation)

    assert_equal(conversation, Conversation.find(conversation.uuid))
  end

  def test_relations
    front_user = FactoryBot.create(:front_user)
    conversation = FactoryBot.create(:conversation, front_user: front_user)
    assert_equal(front_user, conversation.front_user)
    assert_nil(conversation.alert_email)

    alert_email = FactoryBot.create(:alert_email)
    conversation = FactoryBot.create(:conversation, alert_email: alert_email)
    assert_equal(alert_email, conversation.alert_email)
  end

  def test_log_book_events
    front_user = FactoryBot.create(:front_user)
    conversation = FactoryBot.build(:conversation, title: "TITLE", front_user: front_user)

    assert_difference("LogBook::Event.count", 1) do
      conversation.save!
    end

    assert_difference("LogBook::Event.count", 1) do
      conversation.update!(title: "NEW_TITLE")
    end
  end

  def test_add_message
    conversation = FactoryBot.create(:conversation)
    message = FactoryBot.build(:message, conversation: nil)

    assert_difference("Message.count", 1) do
      assert_difference( ->{ conversation.messages.count }, 1) do
        conversation.add_message(message)
      end
    end

    assert_equal(conversation, message.conversation)
    assert_equal(message, conversation.messages.last)
  end
end
