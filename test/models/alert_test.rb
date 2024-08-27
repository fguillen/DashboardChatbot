require "test_helper"

class AlertTest < ActiveSupport::TestCase
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

  def test_on_create_create_cron_job
    alert = FactoryBot.build(:alert, id: "UUID", name: "ALERT", schedule: "10 * * * *")

    Sidekiq::Cron::Job.expects(:create).with(
      name: "Alert-UUID",
      cron: "10 * * * *",
      class: "AlertExecuterJob",
      args: alert
    )

    alert.save!
  end

  def test_on_destroy_destroy_cron_job
    alert = FactoryBot.create(:alert, id: "UUID")

    Sidekiq::Cron::Job.expects(:destroy).with(
      name: "Alert-UUID"
    )

    alert.destroy
  end

  def test_last_time_sent_at
    alert = FactoryBot.create(:alert)
    alert_email_1 = FactoryBot.create(:alert_email, alert: alert, created_at: "2020-04-27")
    alert_email_2 = FactoryBot.create(:alert_email, alert: alert, created_at: "2020-04-25")

    assert_equal("2020-04-27", alert.last_time_sent_at.to_fs(:datedb))
  end

  def test_schedule_to_human
    alert = FactoryBot.build(:alert, schedule: "10 * * * *")
    assert_equal("At 10 minutes past the hour", alert.schedule_to_human)
  end
end
