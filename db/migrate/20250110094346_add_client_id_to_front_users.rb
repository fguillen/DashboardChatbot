class AddClientIdToFrontUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :front_users, :client_id, :string
    add_foreign_key :front_users, :clients, column: :client_id, primary_key: "uuid"
  end
end
