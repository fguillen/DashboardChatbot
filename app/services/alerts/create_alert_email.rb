class Alerts::CreateAlertEmail < Service
  def perform(alert:, content:)
    AlertEmail.create!(
      from: "fernando@playcocola.com",
      to: alert.front_user.email,
      subject: alert.name,
      content: content,
      alert: alert
    )
  end
end
