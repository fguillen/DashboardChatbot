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

    message = FactoryBot.build(:message, conversation: nil)
    refute(message.valid?)
  end

  def test_order_unique_per_conversation
    # order unique per conversation
    conversation_1 = FactoryBot.create(:conversation)
    conversation_2 = FactoryBot.create(:conversation)

    message = FactoryBot.build(:message, conversation: conversation_1, order: 1)
    assert(message.valid?)

    message.save!

    message = FactoryBot.build(:message, conversation: conversation_1, order: 2)
    assert(message.valid?)

    message = FactoryBot.build(:message, conversation: conversation_2, order: 1)
    assert(message.valid?)

    message = FactoryBot.build(:message, conversation: conversation_1, order: 1)
    refute(message.valid?)
  end

  def test_serialize_fields
    tool_calls = [{ id: "ID", function: { name: "NAME" } }]
    message = FactoryBot.create(:message, tool_calls:)
    message.reload
    assert_equal(tool_calls, message.tool_calls)
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
    message = FactoryBot.build(:message, content: "CONTENT", conversation: conversation)

    assert_difference("LogBook::Event.count", 1) do
      message.save!
    end

    assert_difference("LogBook::Event.count", 1) do
      message.update!(content: "NEW_CONTENT")
    end
  end

  def test_on_create_init_order
    conversation = FactoryBot.create(:conversation)
    message = FactoryBot.build(:message, conversation:)
    assert_nil(message.order)
    message.save!
    assert_equal(1, message.order)
  end

  def test_user_reaction_positive?
    message = FactoryBot.create(:message)
    refute(message.user_reaction_positive?)

    _user_reaction = FactoryBot.create(:user_reaction, message:, kind: UserReaction.kinds[:positive])
    message.reload
    assert(message.user_reaction_positive?)
  end

  def test_user_reaction_negative?
    message = FactoryBot.create(:message)
    refute(message.user_reaction_negative?)

    _user_reaction = FactoryBot.create(:user_reaction, message:, kind: UserReaction.kinds[:negative])
    message.reload
    assert(message.user_reaction_negative?)
  end

  def test_is_model_final_answer?
    message = FactoryBot.create(:message, role: "user", content: nil)
    refute(message.is_model_final_answer?)

    message.content = "CONTENT"
    refute(message.is_model_final_answer?)

    message.role = "assistant"
    assert(message.is_model_final_answer?)
  end

  def test_is_debug?
    message = FactoryBot.create(:message, role: "tool")
    assert(message.is_debug?)

    message.role = "user"
    refute(message.is_debug?)

    message.role = "assistant"
    message.content = nil
    assert(message.is_debug?)

    message.content = "CONTENT"
    refute(message.is_debug?)
  end

  def test_content_without_examples
    content = <<~EOS
      This is the content

      ---Examples::INI---
      These are the examples
      """
      Example 1:
      """
      ---Examples::END---
    EOS
    message = FactoryBot.create(:message, content:)
    assert_equal("This is the content", message.content_without_examples)

    message = FactoryBot.create(:message, content: "Without examples")
    assert_equal("Without examples", message.content_without_examples)
  end

  def test_content_examples
    content = <<~EOS
      This is the content

      ---Examples::INI---
      These are the examples
      """
      Example 1:
      """
      ---Examples::END---
    EOS
    message = FactoryBot.create(:message, content:)
    assert_equal("These are the examples\nExample 1:", message.content_examples)

    message = FactoryBot.create(:message, content: "Without examples")
    assert_nil(message.content_examples)
  end
end
