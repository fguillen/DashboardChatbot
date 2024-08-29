require "test_helper"

class Front::ConversationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    setup_front_user
  end

  def test_index
    conversation_1 = FactoryBot.create(:conversation, created_at: "2020-04-25", front_user: @front_user)
    conversation_2 = FactoryBot.create(:conversation, created_at: "2020-04-26", front_user: @front_user)
    conversation_3 = FactoryBot.create(:conversation, created_at: "2020-04-27")

    get front_conversations_path

    assert_template "front/conversations/index"
    assert_primary_keys([conversation_2, conversation_1], assigns(:conversations))
  end

  def test_index_should_not_show_alert_email_conversations
    alert_email = FactoryBot.create(:alert_email)

    conversation_1 = FactoryBot.create(:conversation, created_at: "2020-04-25", front_user: @front_user)
    conversation_2 = FactoryBot.create(:conversation, created_at: "2020-04-26", front_user: @front_user, alert_email: alert_email) # should not be shown
    conversation_3 = FactoryBot.create(:conversation, created_at: "2020-04-27") # should not be shown

    get front_conversations_path

    assert_template "front/conversations/index"
    assert_primary_keys([conversation_1], assigns(:conversations))
  end

  def test_show
    conversation = FactoryBot.create(:conversation, front_user: @front_user)
    message = FactoryBot.create(:message, conversation: conversation)

    get front_conversation_path(conversation)

    assert_template "front/conversations/show"
    assert_equal(conversation, assigns(:conversation))
  end

  def test_new
    get new_front_conversation_path
    assert_template "front/conversations/new"
    assert_not_nil(assigns(:conversation))
  end

  def test_create_invalid
    front_user_1 = FactoryBot.create(:front_user)

    Conversation.any_instance.stubs(:valid?).returns(false)

    post(
      front_conversations_path,
      params: {
        conversation: {
          front_user_id: front_user_1,
          title: "The Title Wadus"
        }
      }
    )

    assert_template "new"
    assert_not_nil(flash[:alert])
  end

  def test_create_valid
    post(
      front_conversations_path,
      params: {
        conversation: {
          title: "The Title Wadus"
        }
      }
    )

    conversation = Conversation.last
    assert_redirected_to [:front, conversation]

    assert_equal("The Title Wadus", conversation.title)
    assert_equal(@front_user, conversation.front_user)
  end

  # def test_on_create_send_notifications
  #   Notifications::OnNewConversationNotificationService.expects(:perform)

  #   post(
  #     front_conversations_path,
  #     params: {
  #       conversation: {
  #         title: "The Title Wadus"
  #       }
  #     }
  #   )
  # end
end
