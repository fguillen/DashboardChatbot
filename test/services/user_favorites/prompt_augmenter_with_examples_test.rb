require "test_helper"

class UserFavorites::PromptAugmenterWithExamplesTest < ActiveSupport::TestCase
  def test_perform
    user_prompt = "USER_PROMPT"
    user_favorite_1 = FactoryBot.create(:user_favorite, model_mental_process: "MENTAL_PROCESS_1.1\nMENTAL_PROCESS_1.2")
    user_favorite_2 = FactoryBot.create(:user_favorite, model_mental_process: "MENTAL_PROCESS_2.1\nMENTAL_PROCESS_2.2")

    UserFavorites::NeighborsFinder.expects(:perform).with(user_prompt:).returns([user_favorite_1, user_favorite_2])

    result = UserFavorites::PromptAugmenterWithExamples.perform(user_prompt:)

    expected_result = <<~EOS
      USER_PROMPT

      Here are some examples from previous similar questions from the user:
      ```markdown
      Example 1:
      MENTAL_PROCESS_1.1
      MENTAL_PROCESS_1.2

      Example 2:
      MENTAL_PROCESS_2.1
      MENTAL_PROCESS_2.2
      ```
    EOS

    assert_equal(expected_result, result)
  end

  def test_perform_when_no_neighbors_found
    user_prompt = "USER_PROMPT"
    UserFavorites::NeighborsFinder.expects(:perform).with(user_prompt:).returns([])

    result = UserFavorites::PromptAugmenterWithExamples.perform(user_prompt:)

    assert_equal(user_prompt, result)
  end
end
