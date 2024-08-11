class CreateAlertEmails < ActiveRecord::Migration[7.1]
  def change
    create_table :alert_emails, id: false do |t|
      t.string :uuid, null: false, limit: 36, index: { unique: true }, primary_key: true
      t.string :subject
      t.text :content
      t.string :from
      t.string :to
      t.string :alert_id, null: false

      t.timestamps
    end

    add_foreign_key :alert_emails, :alerts, column: :alert_id, primary_key: "uuid"
  end
end
