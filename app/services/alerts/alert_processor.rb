class Alerts::AlertProcessor < Service
  def perform(alert)
    messages = Alerts::RequestContent.perform(alert)
    alert_email = Alerts::CreateAlertEmail.perform(alert: alert, messages: messages)
    Alerts::SendEmail.perform(alert_email)
    alert_email
  end
end
