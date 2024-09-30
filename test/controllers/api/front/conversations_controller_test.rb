require "test_helper"

class Api::Front::ConversationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    setup_front_user
  end

  def test_unauthorized
    FactoryBot.create(:front_user)

    get :index
    assert_response :unauthorized

    request.env["Authorization"] = "Bearer NON_EXISTS_TOKEN"
    get :index
    assert_response :unauthorized

    request.env["Authorization"] = "NON_EXISTS_TOKEN"
    get :index
    assert_response :unauthorized

    request.env["Authorization"] = "OtherThing #{@front_user.api_token}"
    get :index
    assert_response :unauthorized
  end

  def test_index
    conversation_1 = FactoryBot.create(:conversation, created_at: "2020-04-25", title: "TITLE_1", front_user: @front_user)
    conversation_2 = FactoryBot.create(:conversation, created_at: "2020-04-26", title: "TITLE_2", front_user: @front_user)
    conversation_3 = FactoryBot.create(:conversation, created_at: "2020-04-27", title: "TITLE_3")

    _message_1 = FactoryBot.create(:message, role: "user", content: "MESSAGE_1", created_at: "2020-04-25 10:10", conversation: conversation_1)
    _message_2 = FactoryBot.create(:message, role: "user", content: "MESSAGE_1", created_at: "2020-04-25 20:10", conversation: conversation_1)

    get api_front_conversations_path(@front_user), headers: { "Authorization" => "Bearer #{@front_user.api_token}" }


    assert_response :success

    write_fixture("responses/api/front/conversations/index.json", JSON.pretty_generate(JSON.parse(response.body)))
    assert_equal(JSON.parse(read_fixture("responses/api/front/conversations/index.json")), JSON.parse(response.body))
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
