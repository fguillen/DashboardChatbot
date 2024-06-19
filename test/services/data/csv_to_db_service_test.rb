require "test_helper"

class Data::CsvToDbServiceTest < ActiveSupport::TestCase
  test "should create table and insert data if force is true" do
    connection = Sequel.connect("sqlite://#{APP_CONFIG["dashboard_db"]}")
    if connection.table_exists?(:articles)
      connection.drop_table(:articles)
    end
    refute(connection.table_exists?(:articles))

    Data::CsvToDbService.perform(fixture("data/articles.csv"), force: true)

    assert(connection.table_exists?(:articles))
    assert_equal(10, connection[:articles].count)
    puts ">>>> connection[:articles].first: #{connection[:articles].first}"
    assert_equal("RR450", connection[:articles].first[:ID])
  end
end
