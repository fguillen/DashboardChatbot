class CreateUserFavorites < ActiveRecord::Migration[7.2]
  def change
    create_table :user_favorites, id: false do |t|
      t.string :uuid, null: false, limit: 36, index: { unique: true }, primary_key: true
      t.text :prompt
      t.text :model_mental_process
      t.vector :prompt_embedding, limit: 384 # all-MiniLM-L6-v2
      t.string :user_reaction_id, null: false

      t.timestamps
    end

    add_foreign_key :user_favorites, :user_reactions, column: :user_reaction_id, primary_key: "uuid"
  end
end
