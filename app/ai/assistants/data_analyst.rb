class Assistants::DataAnalyst < AI::Assistant
  def system_directive
    File.read("#{Rails.root}/config/assistant_instructions.md")
  end

  def client
    AI_CLIENT.client
  end

  def tools
    [
      Tools::Math.new,
      Tools::Database.new(connection_string: APP_CONFIG["dashboard_db_connection"])
    ]
  end
end
