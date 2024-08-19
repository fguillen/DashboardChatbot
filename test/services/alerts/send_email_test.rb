require "test_helper"

class Alerts::SendEmailTest < ActiveSupport::TestCase
  def test_perform
    alert = FactoryBot.create(:alert, name: "ALERT_NAME", prompt: "ALERT_PROMPT", model: "ALERT_MODEL")
    alert_email = FactoryBot.create(:alert_email, to: "ALERT_TO", from: "ALERT_FROM", subject: "ALERT_SUBJECT", alert: alert, content: "ALERT_CONTENT")

    Alerts::SendEmail.perform(alert_email)

    assert !ActionMailer::Base.deliveries.empty?

    email = ActionMailer::Base.deliveries.last

    assert_equal ["ALERT_FROM"], email.from
    assert_equal ["ALERT_TO"], email.to
    assert_equal "[DashboardChatbot] New Alert: ALERT_SUBJECT", email.subject

    # write_fixture("/notifications/front/on_alert_email.txt", email.body.encoded)
    assert_equal(File.read(fixture("/notifications/front/on_alert_email.txt")), email.body.encoded)
  end
end
