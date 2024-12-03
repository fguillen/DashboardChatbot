require "test_helper"

class Front::UserReactionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    setup_front_user
  end

  def test_index
    message_1 = FactoryBot.create(:message, front_user: @front_user)
    message_2 = FactoryBot.create(:message, front_user: @front_user)
    message_3 = FactoryBot.create(:message)
    user_reaction_1 = FactoryBot.create(:user_reaction, created_at: "2020-04-25", message: message_1)
    user_reaction_2 = FactoryBot.create(:user_reaction, created_at: "2020-04-26", message: message_2)
    user_reaction_3 = FactoryBot.create(:user_reaction, created_at: "2020-04-27", message: message_3)

    get front_user_reactions_path

    assert_template "front/user_reactions/index"
    assert_primary_keys([user_reaction_2, user_reaction_1], assigns(:user_reactions))
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

  def test_destroy_from_index
    message = FactoryBot.create(:message, front_user: @front_user)
    user_reaction = FactoryBot.create(:user_reaction, message:)

    delete destroy_from_index_front_user_reaction_path(user_reaction)

    assert_redirected_to front_user_reactions_path
    assert_not(UserReaction.exists?(user_reaction.uuid))
  end


  def test_on_create_if_positive_create_user_favorite
    message = FactoryBot.create(:message, front_user: @front_user)

    expected_args = ->(job_args) {
      assert(job_args.first[:user_reaction].kind_of?(UserReaction))
      assert_equal(message, job_args.first[:user_reaction].message)
    }

    assert_enqueued_with(job: UserFavoriteCreatorJob, args: expected_args) do
      post(
        front_message_user_reactions_path(message),
        params: {
          user_reaction: {
            explanation: "THE EXPLANATION",
            kind: UserReaction.kinds[:positive]
          }
        }
      )
    end
  end
end
