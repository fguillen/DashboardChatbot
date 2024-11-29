require "test_helper"

class Front::UserReactionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    setup_front_user
  end

  def test_create_invalid
    message = FactoryBot.create(:message, front_user: @front_user)

    UserReaction.any_instance.stubs(:valid?).returns(false)

    post(
      front_message_user_reactions_path(message),
      params: {
        user_reaction: {
          kind: UserReaction.kinds[:positive]
        }
      }
    )

    assert_redirected_to front_conversation_path(message.conversation)
    assert_not_nil(flash[:alert])
  end

  def test_create_valid
    message = FactoryBot.create(:message, front_user: @front_user)

    post(
      front_message_user_reactions_path(message),
      params: {
        user_reaction: {
          explanation: "THE EXPLANATION",
          kind: UserReaction.kinds[:positive]
        }
      }
    )

    user_reaction = UserReaction.last
    assert_redirected_to front_conversation_path(message.conversation)

    assert_equal("THE EXPLANATION", user_reaction.explanation)
    assert_equal(message, user_reaction.message)
    assert(user_reaction.positive?)
  end

  def test_destroy
    message = FactoryBot.create(:message, front_user: @front_user)
    user_reaction = FactoryBot.create(:user_reaction, message:)

    delete front_message_user_reaction_path(message, user_reaction)

    assert_redirected_to front_conversation_path(message.conversation)
    assert_not(UserReaction.exists?(user_reaction.uuid))
  end
end
