class CreateClients < ActiveRecord::Migration[7.2]
  def change
    create_table :clients, id: false do |t|
      t.string :uuid, null: false, limit: 36, index: { unique: true }, primary_key: true
      t.string :name, null: false
      t.text :agent_instructions
      t.string :db_connection, null: false
      t.string :api_key, null: false
      t.string :default_model, null: false

      t.timestamps
    end
  end
end
