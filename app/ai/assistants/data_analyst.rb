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

  # TODO: Don't inject the directive multiple times
  # Having realtime date may make the system directive
  # To be injected in the conversation multiple times
  def system_directive
    @system_directive ||=
      begin
        template =
          ERB.new(
            File.read("#{Rails.root}/config/assistant_instructions_data_analyst.md")
          )

        current_year = Date.today.year
        current_date = Date.today.strftime("%Y-%m-%d")

        template.result_with_hash(current_year:, current_date:)
      end
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
