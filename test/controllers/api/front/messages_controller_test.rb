require "test_helper"

class Api::Front::MessagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    setup_front_user
  end

  def test_unauthorized
    conversation = FactoryBot.create(:conversation, front_user: @front_user)

    post(
      api_front_conversation_messages_path(conversation),
      params: {
        message: {
          role: Message.roles[:user],
          content: "The Body Wadus"
        }
      }
    )
    assert_response :unprocessable_entity
  end

  def test_create_invalid
    conversation = FactoryBot.create(:conversation, front_user: @front_user)

    Message.any_instance.stubs(:valid?).returns(false)

    post(
      api_front_conversation_messages_path(conversation),
      params: {
        message: {
          role: Message.roles[:user],
          content: "The Body Wadus"
        }
      },
      headers: { "Authorization" => "Bearer #{@front_user.api_token}" }
    )

    assert_response :unprocessable_entity
    # write_fixture("responses/api/front/messages/create_error.json", JSON.pretty_generate(JSON.parse(response.body)))
    assert_equal(JSON.parse(read_fixture("responses/api/front/messages/create_error.json")), JSON.parse(response.body))
  end

  def test_create_valid
    conversation = FactoryBot.create(:conversation, front_user: @front_user)

    Conversation::ProcessUserMessageService.expects(:perform).with(
      conversation: conversation,
      role: Message.roles[:user],
      content: "MESSAGE_CONTENT",
      model: "MODEL"
    ).returns([{ message: "MESSAGE" }])

    post(
      api_front_conversation_messages_path(conversation),
      params: {
        message: {
          role: Message.roles[:user],
          content: "MESSAGE_CONTENT",
          model: "MODEL",
        }
      },
      headers: { "Authorization" => "Bearer #{@front_user.api_token}" }
    )

    assert_response :success
    # write_fixture("responses/api/front/messages/create.json", JSON.pretty_generate(JSON.parse(response.body)))
    assert_equal(JSON.parse(read_fixture("responses/api/front/messages/create.json")), JSON.parse(response.body))
  end
end
