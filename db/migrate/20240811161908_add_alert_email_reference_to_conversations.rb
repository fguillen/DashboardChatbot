class AddAlertEmailReferenceToConversations < ActiveRecord::Migration[7.1]
  def change
    add_column :conversations, :alert_email_id, :string, null: true
    add_foreign_key :conversations, :alert_emails, column: :alert_email_id, primary_key: "uuid"
  end
end
