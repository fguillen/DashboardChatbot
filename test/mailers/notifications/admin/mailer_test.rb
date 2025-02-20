require "test_helper"

class Notifications::Admin::MailerTest < ActionMailer::TestCase
  def test_on_new_article
    admin_user = FactoryBot.create(:admin_user, email: "admin@email.com")
    article = FactoryBot.create(:article, title: "NEW_ARTICLE", uuid: "ARTICLE_UUID")

    email = Notifications::Admin::Mailer.on_new_article(admin_user, article).deliver_now
    assert !ActionMailer::Base.deliveries.empty?

    assert_equal ["fernando@playcocola.com"], email.from
    assert_equal ["admin@email.com"], email.to
    assert_equal "[DashboardChatbot] New Article: NEW_ARTICLE", email.subject

    # write_fixture("/notifications/admin/on_new_article.txt", email.body.encoded)
    assert_equal(File.read(fixture("/notifications/admin/on_new_article.txt")), email.body.encoded)
  end
end
