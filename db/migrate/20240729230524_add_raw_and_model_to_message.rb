class AddRawAndModelToMessage < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :raw, :json
    add_column :messages, :model, :string
  end
end
