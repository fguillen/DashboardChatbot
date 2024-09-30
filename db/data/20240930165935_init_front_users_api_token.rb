# frozen_string_literal: true

class InitFrontUsersApiToken < ActiveRecord::Migration[7.1]
  def up
    FrontUser.all.each do |front_user|
      front_user.initialize_api_token
      front_user.save!
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
