require "test_helper"

class UserFavoriteTest < ActiveSupport::TestCase
  def test_fixture_is_valid
    assert FactoryBot.create(:user_favorite).valid?
  end

  def test_uuid_on_create
    user_reaction = FactoryBot.create(:user_reaction)
    user_favorite = FactoryBot.build(:user_favorite, user_reaction:)
    assert_nil(user_favorite.uuid)

    user_favorite.save!
    assert_not_nil(user_favorite.uuid)
  end

  def test_primary_key
    user_favorite = FactoryBot.create(:user_favorite)

    assert_equal(user_favorite, UserFavorite.find(user_favorite.uuid))
  end

  def test_relations
    front_user = FactoryBot.create(:front_user)
    message = FactoryBot.create(:message, front_user:)
    user_reaction = FactoryBot.create(:user_reaction, message:)
    user_favorite = FactoryBot.create(:user_favorite, user_reaction:)

    assert_equal(user_reaction, user_favorite.user_reaction)
    assert_equal(front_user, user_favorite.front_user)
  end

  def test_log_book_events
    user_reaction = FactoryBot.create(:user_reaction)
    user_favorite = FactoryBot.build(:user_favorite, user_reaction:)

    assert_difference("LogBook::Event.count", 1) do
      user_favorite.save!
    end
  end

  def test_scope_order_by_recent
    user_favorite_1 = FactoryBot.create(:user_favorite, created_at: "2021-04-01")
    user_favorite_2 = FactoryBot.create(:user_favorite, created_at: "2021-04-03")
    user_favorite_3 = FactoryBot.create(:user_favorite, created_at: "2021-04-02")

    assert_primary_keys([user_favorite_2, user_favorite_3, user_favorite_1], UserFavorite.order_by_recent)
  end

  def test_uniqueness_by_user_reaction
    user_reaction = FactoryBot.create(:user_reaction)
    user_favorite_1 = FactoryBot.create(:user_favorite, user_reaction:)
    assert(user_favorite_1.valid?)

    user_favorite_2 = FactoryBot.build(:user_favorite, user_reaction:)
    assert_not(user_favorite_2.valid?)
  end
end
