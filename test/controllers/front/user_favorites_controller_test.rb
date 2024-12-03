require "test_helper"

class Front::UserFavoritesControllerTest < ActionDispatch::IntegrationTest
  def setup
    setup_front_user
  end

  def test_index
    message_1 = FactoryBot.create(:message, front_user: @front_user)
    message_2 = FactoryBot.create(:message, front_user: @front_user)
    message_3 = FactoryBot.create(:message)

    user_reaction_1 = FactoryBot.create(:user_reaction, message: message_1)
    user_reaction_2 = FactoryBot.create(:user_reaction, message: message_2)
    user_reaction_3 = FactoryBot.create(:user_reaction, message: message_3)

    user_favorite_1 = FactoryBot.create(:user_favorite, created_at: "2020-04-25", user_reaction: user_reaction_1)
    user_favorite_2 = FactoryBot.create(:user_favorite, created_at: "2020-04-26", user_reaction: user_reaction_2)
    user_favorite_3 = FactoryBot.create(:user_favorite, created_at: "2020-04-27", user_reaction: user_reaction_3)

    get front_user_favorites_path

    assert_template "front/user_favorites/index"
    assert_primary_keys([user_favorite_2, user_favorite_1], assigns(:user_favorites))
  end

  def test_destroy
    message = FactoryBot.create(:message, front_user: @front_user)
    user_reaction = FactoryBot.create(:user_reaction, message:)
    user_favorite = FactoryBot.create(:user_favorite, user_reaction:)

    delete front_user_favorite_path(user_favorite)

    assert_redirected_to front_user_favorites_path
    assert_not(UserFavorite.exists?(user_favorite.uuid))
  end
end
