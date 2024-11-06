class Tools::SendCsv < LangMini::Tool
  def initialize(front_user:)
    @front_user = front_user
  end

  def tool_description_path
    "#{__dir__}/send_csv.json"
  end

  def send_csv(subject:, data:)
    puts ">>>> Sending CSV with: subject: #{subject}"
    puts ">>>> data: #{data}"

    data_hash = JSON.parse(data)

    puts ">>>> data_hash: #{JSON.pretty_generate(data_hash)}"

    # raise "Test error"
    SendCsv.perform(
      subject:,
      data: data_hash,
      user: @front_user
    )

    message = "The CSV has been sent to #{@front_user.email}."
    puts ">>>>> #{message}"

    message
  end
end
