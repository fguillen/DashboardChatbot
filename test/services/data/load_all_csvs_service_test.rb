require "test_helper"

class Data::LoadAllCsvsServiceTest < ActiveSupport::TestCase
  test "should create table from articles.csv" do

    Data::LoadAllCsvsService.perform

    assert(false, "Implement this test")
  end
end
