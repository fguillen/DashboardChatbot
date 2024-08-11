require "test_helper"

class AlertEmailTest < ActiveSupport::TestCase
  def test_relations
    alert = FactoryBot.create(:alert)
    alert_email = FactoryBot.create(:alert_email, alert: alert)

    assert_equal(alert, alert_email.alert)
  end
end
