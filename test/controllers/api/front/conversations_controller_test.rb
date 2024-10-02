require "test_helper"

class Api::Front::ConversationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    setup_front_user
  end

  def test_unauthorized
    FactoryBot.create(:front_user)

    get(
      api_front_conversations_path(@front_user)
    )
    assert_response :unprocessable_entity

    get(
      api_front_conversations_path(@front_user),
      headers: { "Authorization" => "Bearer NON_EXISTS_TOKEN" }
    )
    assert_response :unprocessable_entity

    get(
      api_front_conversations_path(@front_user),
      headers: { "Authorization" => "NON_EXISTS_TOKEN" }
    )
    assert_response :unprocessable_entity

    get(
      api_front_conversations_path(@front_user),
      headers: { "Authorization" => "OtherThing #{@front_user.api_token}" }
    )
    assert_response :unprocessable_entity
  end

  def test_index
    conversation_1 = FactoryBot.create(:conversation, created_at: "2020-04-25", title: "TITLE_1", front_user: @front_user, uuid: "CONVERSATION_UUID_1")
    _conversation_2 = FactoryBot.create(:conversation, created_at: "2020-04-26", title: "TITLE_2", front_user: @front_user, uuid: "CONVERSATION_UUID_2")
    _conversation_3 = FactoryBot.create(:conversation, created_at: "2020-04-27", title: "TITLE_3")

    _message_1 = FactoryBot.create(:message, role: "user", content: "MESSAGE_1", created_at: "2020-04-25 10:10", conversation: conversation_1, uuid: "MESSAGE_UUID_1")
    _message_2 = FactoryBot.create(:message, role: "user", content: "MESSAGE_1", created_at: "2020-04-25 20:10", conversation: conversation_1, uuid: "MESSAGE_UUID_2")

    get(
      api_front_conversations_path(@front_user),
      headers: { "Authorization" => "Bearer #{@front_user.api_token}" }
    )

    assert_response :success

    # write_fixture("responses/api/front/conversations/index.json", JSON.pretty_generate(JSON.parse(response.body)))
    assert_equal(JSON.parse(read_fixture("responses/api/front/conversations/index.json")), JSON.parse(response.body))
  end

  def test_show
    conversation = FactoryBot.create(:conversation, front_user: @front_user, uuid: "CONVERSATION_UUID", created_at: "2024-10-01 09:10", title: "CONVERSATION_TITLE")
    _message = FactoryBot.create(:message, conversation: conversation, uuid: "MESSAGE_UUID", role: "user", content: "MESSAGE_CONTENT", created_at: "2024-10-01 10:10")

    get(
      api_front_conversation_path(conversation),
      headers: { "Authorization" => "Bearer #{@front_user.api_token}" }
    )
    assert_response :success

    # write_fixture("responses/api/front/conversations/show.json", JSON.pretty_generate(JSON.parse(response.body)))
    assert_equal(JSON.parse(read_fixture("responses/api/front/conversations/show.json")), JSON.parse(response.body))
  end

  def test_create_invalid
    front_user_1 = FactoryBot.create(:front_user)

    Conversation.any_instance.stubs(:valid?).returns(false)

    post(
      api_front_conversations_path,
      params: {
        conversation: {
          title: "The Title Wadus"
        }
      },
      headers: { "Authorization" => "Bearer #{@front_user.api_token}" }
    )

    assert_response :unprocessable_entity
    # write_fixture("responses/api/front/conversations/create_error.json", JSON.pretty_generate(JSON.parse(response.body)))
    assert_equal(JSON.parse(read_fixture("responses/api/front/conversations/create_error.json")), JSON.parse(response.body))
  end

  def test_create_valid
    Conversation.any_instance.expects(:generate_uuid).returns("CONVERSATION_UUID")

    post(
      api_front_conversations_path,
      params: {
        conversation: {
          title: "The Title Wadus"
        }
      },
      headers: { "Authorization" => "Bearer #{@front_user.api_token}" }
    )

    assert_response :success
    # write_fixture("responses/api/front/conversations/create.json", JSON.pretty_generate(JSON.parse(response.body)))
    assert_equal(JSON.parse(read_fixture("responses/api/front/conversations/create.json")), JSON.parse(response.body))

    conversation = Conversation.last
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
