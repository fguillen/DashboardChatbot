require "test_helper"

class SendCsvTest < ActiveSupport::TestCase
  def test_perform
    front_user = FactoryBot.create(:front_user, email: "test@example.com")
    data = [{key1: "value1", key2: "value2"}, {key1: "value3", key2: "value4"}]

    SendCsv.perform(subject: "THE_SUBJECT", data:, user: front_user)

    assert !ActionMailer::Base.deliveries.empty?

    email = ActionMailer::Base.deliveries.last

    assert_equal ["fernando@playcocola.com"], email.from
    assert_equal ["test@example.com"], email.to
    assert_equal "[DashboardChatbot] THE_SUBJECT", email.subject

    # write_fixture("/notifications/front/send_csv.txt", email.text_part.body.to_s)
    assert_equal(File.read(fixture("/notifications/front/send_csv.txt")), email.text_part.body.to_s)

    # attachment
    assert_equal(1, email.attachments.count)
    assert_equal("text/csv", email.attachments.first.mime_type)
    assert_equal("dashboard_chatbot_data.csv", email.attachments.first.filename)

    # write_fixture("/notifications/front/attached_csv.csv", email.attachments.first.body.encoded)
    assert_equal(File.read(fixture("/notifications/front/attached_csv.csv")), email.attachments.first.body.encoded)
  end
end
