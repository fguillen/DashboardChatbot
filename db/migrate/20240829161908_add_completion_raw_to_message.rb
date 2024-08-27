class AddCompletionRawToMessage < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :completion_raw, :json
  end
end
