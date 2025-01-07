require "test_helper"

class Admin::UserReactionsControllerTest < ActionController::TestCase
  def setup
    setup_admin_user
  end

  def test_index
    user_reaction_1 = FactoryBot.create(:user_reaction, created_at: "2020-04-25")
    user_reaction_2 = FactoryBot.create(:user_reaction, created_at: "2020-04-26")

    get :index

    assert_template "admin/user_reactions/index"
    assert_primary_keys([user_reaction_2, user_reaction_1], assigns(:user_reactions))
  end
end
