require "test_helper"

class Admin::ConversationsControllerTest < ActionController::TestCase
  def setup
    setup_admin_user
  end

  def test_index
    conversation_1 = FactoryBot.create(:conversation, created_at: "2020-04-25")
    conversation_2 = FactoryBot.create(:conversation, created_at: "2020-04-26")

    get :index

    assert_template "admin/conversations/index"
    assert_primary_keys([conversation_2, conversation_1], assigns(:conversations))
  end

  def test_show
    conversation = FactoryBot.create(:conversation)

    get :show, params: { id: conversation }

    assert_template "admin/conversations/show"
    assert_equal(conversation, assigns(:conversation))
  end

  def test_destroy
    conversation = FactoryBot.create(:conversation)

    delete :destroy, params: { id: conversation }

    assert_redirected_to :admin_conversations
    assert_not_nil(flash[:notice])

    assert !Conversation.exists?(conversation.id)
  end
end
