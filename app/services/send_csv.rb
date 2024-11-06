require "csv"
class SendCsv < Service
  def perform(subject:, data:, user:)
    csv = generate_csv(data: data)
    Notifications::Front::Mailer.send_csv(subject:, csv:, user:).deliver_now
  end

  private

  def generate_csv(data:)
    CSV.generate do |csv|
      csv << data.first.keys
      data.each { |row| csv << row.values }
    end
  end
end
