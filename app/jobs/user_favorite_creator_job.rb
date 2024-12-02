class UserFavoriteCreatorJob < ApplicationJob
  def perform(user_reaction:)
    UserFavorites::UserFavoriteCreator.perform(user_reaction:)
  end
end
