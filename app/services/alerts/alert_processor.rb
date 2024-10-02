class Alerts::AlertProcessor < Service
  def perform(alert)
    conversation = Conversation.create!(front_user: alert.front_user, title: alert.name)

    Conversation::ProcessUserMessageService.perform(
      conversation,
      "user",
      alert.prompt,
      alert.model
    )

    alert_email_content =
      Alerts::GenerateAlertEmailContent.perform(
        alert:,
        conversation:
      )

    alert_email =
      Alerts::CreateAlertEmail.perform(
        alert: alert,
        content: alert_email_content
      )

    conversation.update!(alert_email:)
    Alerts::SendEmail.perform(alert_email)
    alert_email
  end
end
