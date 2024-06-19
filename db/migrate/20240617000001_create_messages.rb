class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages, id: false do |t|
      t.string :uuid, null: false, limit: 36, index: { unique: true }, primary_key: true
      t.integer :order, null: false
      t.string :role, null: false
      t.text :content
      t.text :tool_calls
      t.string :tool_call_id
      t.string :conversation_id

      t.timestamps
    end

    add_foreign_key :messages, :conversations, column: :conversation_id, primary_key: "uuid"
    add_index :messages, [:order, :conversation_id], unique: true
  end
end
