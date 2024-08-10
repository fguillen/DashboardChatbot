class CreateAlerts < ActiveRecord::Migration[7.1]
  def change
    create_table :alerts, id: false do |t|
      t.string :uuid, null: false, limit: 36, index: { unique: true }, primary_key: true
      t.string :schedule, null: false
      t.text :context, null: false
      t.text :prompt, null: false
      t.string :name, default: "Untitled"
      t.string :conversation_id
      t.string :front_user_id, null: false

      t.timestamps
    end

    add_foreign_key :alerts, :conversations, column: :conversation_id, primary_key: "uuid"
    add_foreign_key :alerts, :front_users, column: :front_user_id, primary_key: "uuid"
  end
end
