class AddApiTokenToFrontUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :front_users, :api_token, :string
  end
end
