class Alerts::SendEmail < Service
  def perform(alert_email)
    Notifications::Front::Mailer.on_alert_email(alert_email).deliver_now
  end
end
