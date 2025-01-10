# frozen_string_literal: true

class InitFrontUsersClientId < ActiveRecord::Migration[7.2]
  def up
    FrontUser.all.each do |front_user|
      front_user.client = Client.first
      front_user.save!
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
