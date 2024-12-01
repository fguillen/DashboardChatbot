require "test_helper"

class UserFavorites::GenerateEmbedsTest < ActiveSupport::TestCase
  def test_generate_embeds

    result = Example::MyExample.perform("MESSAGE")

    assert_equal("MESSAGE", result)
  end
end
