class Alerts::CreateAlertEmail < Service
  def perform(alert:, content:)
    AlertEmail.create!(
      from: "fernando@playcocola.com",
      to: FrontUser.order_by_recent.first.email, # TODO: Get the FrontUser from the alert
      subject: alert.name,
      content: content,
      alert: alert
    )
  end
end
