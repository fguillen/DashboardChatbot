class UserFavorites::PromptAugmenterWithExamples < Service
  def perform(user_prompt:)
    neighbors = UserFavorites::NeighborsFinder.perform(user_prompt:)
    return user_prompt if neighbors.empty?


    result_prompt = <<~PROMPT
      #{user_prompt}

      Here are some examples from previous similar questions from the user:
      ```markdown
      #{generate_examples(neighbors)}
      ```
    PROMPT
  end

  private

  def generate_examples(neighbors)
    result = []

    neighbors.each.with_index do |neighbor, index|
      result << "Example #{index + 1}:"
      result << neighbor.model_mental_process
      result << ""
    end

    result.join("\n").strip
  end
end
