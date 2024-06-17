require "test_helper"

class MessageTest < ActiveSupport::TestCase
  def test_fixture_is_valid
    assert FactoryBot.create(:message).valid?
  end

  def test_validations
    message = FactoryBot.build(:message)
    assert(message.valid?)

    message = FactoryBot.build(:message, role: nil)
    refute(message.valid?)

    message = FactoryBot.build(:message, role: Message.roles[:user])
    assert(message.valid?)

    assert_raise(ArgumentError) do
      message = FactoryBot.build(:message, role: "NO_EXITS")
    end

    message = FactoryBot.build(:message, body: nil)
    refute(message.valid?)

    message = FactoryBot.build(:message, body: "")
    refute(message.valid?)

    message = FactoryBot.build(:message, body: "A" * 65_536)
    refute(message.valid?)

    message = FactoryBot.build(:message, body: "A" * 30)
    assert(message.valid?)

    message = FactoryBot.build(:message, conversation: nil)
    refute(message.valid?)
  end

  def test_uuid_on_create
    message = FactoryBot.build(:message)
    assert_nil(message.uuid)

    message.save!

    assert_not_nil(message.uuid)
  end

  def test_primary_key
    message = FactoryBot.create(:message)

    assert_equal(message, Message.find(message.uuid))
  end

  def test_relations
    conversation = FactoryBot.create(:conversation)
    message = FactoryBot.create(:message, conversation: conversation)

    assert_equal(conversation, message.conversation)
  end

  def test_log_book_events
    conversation = FactoryBot.create(:conversation)
    message = FactoryBot.build(:message, body: "BODY", conversation: conversation)

    assert_difference("LogBook::Event.count", 1) do
      message.save!
    end

    assert_difference("LogBook::Event.count", 1) do
      message.update!(body: "NEW_BODY")
    end
  end
end
