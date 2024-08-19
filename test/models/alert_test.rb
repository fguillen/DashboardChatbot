require "test_helper"

class AlertTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def test_on_destroy_destroy_dependencies
    alert = FactoryBot.create(:alert)
    alert_email = FactoryBot.create(:alert_email, alert: alert)
    conversation = FactoryBot.create(:conversation, alert_email: alert_email)

    assert_difference("Alert.count", -1) do
      assert_difference("AlertEmail.count", -1) do
        assert_difference("Conversation.count", -1) do
          alert.destroy
        end
      end
    end

    refute Alert.exists?(alert.id)
    refute AlertEmail.exists?(alert_email.id)
    refute Conversation.exists?(conversation.id)
  end
end
