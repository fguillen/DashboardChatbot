class Assistants::DataAnalyst < LangMini::Assistant
  def initialize(
    model: LangMini::DEFAULT_MODEL,
    lang_mini_conversation: nil,
    on_new_message: nil,
    front_user:
  )
    super(model:, conversation: lang_mini_conversation, on_new_message:, client: self.client)
    @front_user = front_user
  end

  def system_directive
    File.read("#{Rails.root}/config/assistant_instructions_data_analyst.md")
  end

  def client
    AI_CLIENT
  end

  def tools
    [
      LangMini::Tools::Math.new,
      LangMini::Tools::Database.new(connection_string: APP_CONFIG["dashboard_db_connection"]),
      Tools::Chart.new,
      Tools::AlertCreator.new(front_user: @front_user),
      Tools::SendCsv.new(front_user: @front_user)
    ]
  end
end
