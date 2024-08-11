class Alerts::CreateAlertEmail < Service
  def perform(alert:, messages:)
    AlertEmail.create!(
      from: "alerts@#{APP_CONFIG["host"]}",
      to: FrontUser.order_by_recent.first.email, # TODO: Get the FrontUser from the alert
      subject: alert.name,
      content: messages.join("\n"),
      alert: alert
    )
  end
end
