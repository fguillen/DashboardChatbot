require "test_helper"

class Admin::ImpersonationsControllerTest < ActionController::TestCase
  def setup
    setup_admin_user
  end

  def test_create
    front_user = FactoryBot.create(:front_user)

    post(
      :create,
      params: {
        front_user_id: front_user
      }
    )

    assert_redirected_to front_root_path
  end

  def test_create_when_no_admin_user
    @controller.stubs(:current_admin_user).returns(nil)

    post(
      :create,
      params: {
        front_user_id: "ANY"
      }
    )

    assert_response 302
    assert_redirected_to :admin_login
  end
end
