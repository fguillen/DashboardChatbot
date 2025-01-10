# frozen_string_literal: true

class InsertClientTest < ActiveRecord::Migration[7.2]
  CLIENT_NAME = "Client Test"

  def up
    Client.create!(
      name: CLIENT_NAME,
      db_connection: "postgresql://localhost:5432/test",
      api_key: "API_KEY",
      default_model: "DEFAULT_MODEL",
    )
  end

  def down
    Client.find_by(name: CLIENT_NAME).try(:destroy)
  end
end
