require "test_helper"

class ClientTest < ActiveSupport::TestCase
  def test_fixture_is_valid
    assert FactoryBot.create(:client).valid?
  end

  def test_validations
    client = FactoryBot.build(:client)
    assert(client.valid?)

    client = FactoryBot.build(:client, name: nil)
    refute(client.valid?)

    client = FactoryBot.build(:client, db_connection: nil)
    refute(client.valid?)

    client = FactoryBot.build(:client, api_key: nil)
    refute(client.valid?)

    client = FactoryBot.build(:client, default_model: nil)
    refute(client.valid?)
  end

  def test_uuid_on_create
    client = FactoryBot.build(:client)
    assert_nil(client.uuid)

    client.save!

    assert_not_nil(client.uuid)
  end

  def test_primary_key
    client = FactoryBot.create(:client)

    assert_equal(client, Client.find(client.uuid))
  end

  def test_relations
    client = FactoryBot.create(:client)
    front_user = FactoryBot.create(:front_user, client:)

    assert_primary_key([front_user], client.front_users)
  end

  def test_log_book_events
    client = FactoryBot.build(:client, name: "NAME")

    assert_difference("LogBook::Event.count", 1) do
      client.save!
    end

    assert_difference("LogBook::Event.count", 1) do
      client.update!(name: "NEW_NAME")
    end
  end
end
