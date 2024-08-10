class CreateAlerts < ActiveRecord::Migration[7.1]
  def change
    create_table :alerts do |t|
      t.string :schedule, null: false
      t.text :query, null: false
      t.string :name, default: "Untitled"

      t.timestamps
    end
  end
end
