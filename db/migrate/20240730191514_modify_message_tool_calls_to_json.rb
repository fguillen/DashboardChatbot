class ModifyMessageToolCallsToJson < ActiveRecord::Migration[7.1]
  def change
    remove_column :messages, :tool_calls
    add_column :messages, :tool_calls, :json
  end
end
