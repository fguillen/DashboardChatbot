class Notifications::Front::Mailer < ActionMailer::Base
  default from: APP_CONFIG["admin_email"]
  layout "layouts/mailer"

  def on_new_article(front_user, article)
    @article = article
    @article_link = front_article_url(@article, host: APP_CONFIG["host"])

    mail(
      to: front_user.email,
      subject: "[DashboardChatbot] New Article: #{@article.title}"
    )
  end

  def on_alert_email(alert_email)
    @alert_email = alert_email

    mail(
      from: alert_email.from,
      to: alert_email.to,
      subject: "[DashboardChatbot] New Alert: #{@alert_email.subject}"
    )
  end
end
