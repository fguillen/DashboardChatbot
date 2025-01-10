require "test_helper"

class Admin::ClientsControllerTest < ActionController::TestCase
  def setup
    setup_admin_user
  end

  def test_index
    client_1 = FactoryBot.create(:client, created_at: "2020-04-25")
    client_2 = FactoryBot.create(:client, created_at: "2020-04-26")

    get :index

    assert_template "admin/clients/index"
    assert_primary_keys([client_2, client_1], assigns(:clients))
  end

  def test_show
    client = FactoryBot.create(:client)

    get :show, params: { id: client }

    assert_template "admin/clients/show"
    assert_equal(client, assigns(:client))
  end

  def test_new
    get :new
    assert_template "admin/clients/new"
    assert_not_nil(assigns(:client))
  end

  def test_create_invalid
    Client.any_instance.stubs(:valid?).returns(false)

    post(
      :create,
      params: {
        client: {
          name: "NAME",
          db_connection: "DB_CONNECTION",
          api_key: "API_KEY",
          default_model: "DEFAULT_MODEL"
        }
      }
    )

    assert_template "new"
    assert_response :unprocessable_entity
    assert_not_nil(flash[:alert])
  end

  def test_create_valid
    post(
      :create,
      params: {
        client: {
          name: "NAME",
          db_connection: "DB_CONNECTION",
          api_key: "API_KEY",
          default_model: "DEFAULT_MODEL",
          agent_instructions: "AGENT_INSTRUCTIONS",
        }
      }
    )

    client = Client.last
    assert_redirected_to [:admin, client]

    assert_equal("NAME", client.name)
    assert_equal("DB_CONNECTION", client.db_connection)
    assert_equal("API_KEY", client.api_key)
    assert_equal("DEFAULT_MODEL", client.default_model)
    assert_equal("AGENT_INSTRUCTIONS", client.agent_instructions)
  end

  def test_edit
    client = FactoryBot.create(:client)

    get :edit, params: { id: client }

    assert_template "edit"
    assert_equal(client, assigns(:client))
  end

  def test_update_invalid
    client = FactoryBot.create(:client)

    Client.any_instance.stubs(:valid?).returns(false)

    put(
      :update,
      params: {
        id: client,
        client: {
          name: "NEW_NAME"
        }
      }
    )

    assert_template "edit"
    assert_response :unprocessable_entity
    assert_not_nil(flash[:alert])
  end

  def test_update_valid
    client = FactoryBot.create(:client)

    put(
      :update,
      params: {
        id: client,
        client: {
          name: "NEW_NAME"
        }
      }
    )

    assert_redirected_to [:admin, client]
    assert_not_nil(flash[:notice])

    client.reload
    assert_equal("NEW_NAME", client.name)
  end

  def test_destroy
    client = FactoryBot.create(:client)

    delete :destroy, params: { id: client }

    assert_redirected_to :admin_clients
    assert_not_nil(flash[:notice])

    assert !Client.exists?(client.id)
  end

  def test_conversations
    client = FactoryBot.create(:client)
    front_user = FactoryBot.create(:front_user, client: client)

    get(
      :front_users,
      params: {
        id: client
      }
    )

    assert_primary_keys([front_user], assigns(:front_users))
  end


  def test_log_book_events
    client = FactoryBot.create(:client)
    log_book_event = FactoryBot.create(:log_book_event, historizable: client)

    get(
      :log_book_events,
      params: {
        id: client
      }
    )

    assert_equal(log_book_event.id, assigns(:log_book_events).first.id)
    assert_template "log_book_events"
  end
end
