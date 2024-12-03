class AddAssistantNameToMessages < ActiveRecord::Migration[7.2]
  def change
    add_column :messages, :assistant_name, :string, default: nil
  end
end
