require "test_helper"

class Front::MessagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    setup_front_user
  end

  def test_create_invalid
    conversation = FactoryBot.create(:conversation, front_user: @front_user)

    Message.any_instance.stubs(:valid?).returns(false)

    post(
      front_conversation_messages_path(conversation),
      params: {
        message: {
          role: Message.roles[:user],
          content: "The Body Wadus"
        }
      }
    )

    assert_template "front/conversations/_conversation"
    assert_not_nil(flash[:alert])
  end

  def test_create_valid
    conversation = FactoryBot.create(:conversation, front_user: @front_user)

    Conversation::ProcessUserMessageService.expects(:perform).with(
      conversation:,
      role: Message.roles[:user],
      content: "The Body Wadus",
      model: nil
    ).returns([{ message: "MESSAGE" }])

    post(
      front_conversation_messages_path(conversation),
      params: {
        message: {
          role: Message.roles[:user],
          content: "The Body Wadus"
        }
      }
    )

    assert_redirected_to [:front, conversation]
  end

  # def test_on_create_send_notifications
  #   Notifications::OnNewMessageNotificationService.expects(:perform)

  #   post(
  #     front_messages_path,
  #     params: {
  #       message: {
  #         title: "The Body Wadus",
  #         content: "The Body Wadus Wadus Wadus Wadus",
  #         tag_list: "one, two",
  #         pic: fixture_file_upload("yourule.png")
  #       }
  #     }
  #   )
  # end
end
