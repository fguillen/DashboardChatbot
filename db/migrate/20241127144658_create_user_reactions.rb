class CreateUserReactions < ActiveRecord::Migration[7.2]
  def change
    create_enum :reaction_kind, ["positive", "negative"]

    create_table :user_reactions, id: false do |t|
      t.string :uuid, null: false, limit: 36, index: { unique: true }, primary_key: true
      t.string :message_id, null: false
      t.enum :kind, enum_type: "reaction_kind", null: false
      t.text :explanation

      t.timestamps
    end

    add_foreign_key :user_reactions, :messages, column: :message_id, primary_key: "uuid"
  end
end
