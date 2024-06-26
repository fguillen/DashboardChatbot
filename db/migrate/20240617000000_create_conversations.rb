class CreateConversations < ActiveRecord::Migration[5.2]
  def change
    create_table :conversations, id: false do |t|
      t.string :uuid, null: false, limit: 36, index: { unique: true }, primary_key: true
      t.string :title, null: false
      t.string :front_user_id

      t.timestamps
    end

    add_foreign_key :conversations, :front_users, column: :front_user_id, primary_key: "uuid"
  end
end
